package ui.tabedpane
{
	import array.del;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ui.button.Button;
	import ui.core.Component;
	
	[Event(name="tabFocusIn", type="ui.events.TabedPaneEvent")]
	[Event(name="tabFocusOut", type="ui.events.TabedPaneEvent")]
	[Event(name="change", type="flash.events.Event")]
	
	public class AbstractTabedPane extends Component
	{
		protected const tabList:Array = [];
		private const visibleTabList:Array = [];
		
		private var _titleButtonFactory:Class;
		private var _tabGap:Number = 0;
		private var _maxVisibleTabCount:int;
		private var _allowEmptyFocusTab:Boolean;
		
		public function AbstractTabedPane()
		{
			super();
		}
		
		private function createTitleButton():Button
		{
			if(titleButtonFactory){
				return new titleButtonFactory();
			}
			throw new Error("titleButtonFactory must be set!");
		}
		
		public function getTab(component:Component):Tab
		{
			return getTabAt(findTabIndex(component));
		}
		
		public function getTabAt(index:int):Tab
		{
			return tabList[index];
		}
		
		public function addTab(component:Component, title:String=null):void
		{
			addTabAt(component, tabList.length, title);
		}
		
		public function addTabAt(component:Component, index:int, title:String=null):void
		{
			const tabCount:int = tabList.length;
			index = (index < 0) ? 0 : (index > tabCount ? tabCount : index);
			
			var btn:Button = createTitleButton();
			btn.addEventListener(MouseEvent.CLICK, __onItemClick);
			btn.label.text = title;
			
			var tab:Tab = new Tab(btn, component, index, this);
			addChildAt(btn, numChildren-tabCount+index);
			tabList.splice(index, 0, tab);
			
			relayout();
			checkFocusTab(tab);
		}
		
		public function removeTab(component:Component):void
		{
			removeTabAt(findTabIndex(component));
		}
		
		public function removeTabAt(index:int):void
		{
			var tab:Tab = tabList[index];
			if(null == tab){
				return;
			}
			tab.title.removeEventListener(MouseEvent.CLICK, __onItemClick);
			removeChild(tab.title);
			if(tab.isContentShowing()){
				removeChild(tab.component);
				array.del(visibleTabList, tab);
			}
			array.del(tabList, tab);
			relayout();
			checkFocusTab(tab);
		}
		
		public function clear():void
		{
			for each(var tab:Tab in tabList){
				if(tab.isContentShowing()){
					tab.hideContent();
				}
				tab.title.removeEventListener(MouseEvent.CLICK, __onItemClick);
				removeChild(tab.title);
			}
			tabList.length = 0;
			visibleTabList.length = 0;
		}
		
		private function findTabIndex(component:Component):int
		{
			for(var index:int = tabList.length - 1; index >= 0; index--){
				var tab:Tab = tabList[index];
				if(tab.component == component){
					return index;
				}
			}
			return -1;
		}
		
		private function __onItemClick(event:MouseEvent):void
		{
			toggleTab(findTabByButton(event.currentTarget as Button));
		}
		
		private function toggleTab(tab:Tab):void
		{
			if(tab.isContentShowing()){
				collapseTab(tab);
			}else{
				expandTab(tab);
			}
			
			relayout();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function expandTab(tab:Tab):void
		{
			if(tab.isContentShowing()){
				return;
			}
			tab.showContent();
			visibleTabList.push(tab);
			if((0 < maxVisibleTabCount) && (maxVisibleTabCount < visibleTabList.length)){
				tab = visibleTabList.shift();
				tab.hideContent();
			}
		}
		
		private function collapseTab(tab:Tab):void
		{
			if(tab.isContentShowing() == false){
				return;
			}
			if((false == allowEmptyFocusTab) && (visibleTabList.length <= 1)){
				return;
			}
			tab.hideContent();
			array.del(visibleTabList, tab);
		}
		
		protected function relayout():void
		{
			var offsetY:Number = 0;
			for each(var tab:Tab in tabList)
			{
				tab.title.y = offsetY;
				offsetY += tab.title.height;
				
				if(tab.isContentShowing()){
					tab.component.y = offsetY;
					offsetY += tab.component.height;
				}
				
				offsetY += tabGap;;
			}
			this.height = offsetY - tabGap;
		}
		
		private function findTabByButton(btn:Button):Tab
		{
			for each(var tab:Tab in tabList){
				if(tab.title == btn){
					return tab;
				}
			}
			return null;
		}
		
		public function toggleTabAt(index:int):void
		{
			toggleTab(tabList[index]);
		}
		
		public function get allowEmptyFocusTab():Boolean
		{
			return _allowEmptyFocusTab;
		}
		
		public function set allowEmptyFocusTab(value:Boolean):void
		{
			_allowEmptyFocusTab = value;
			checkFocusTab(tabList.length > 0 ? tabList[0] : null);
		}
		
		private function checkFocusTab(tab:Tab):void
		{
			if(allowEmptyFocusTab || visibleTabList.length > 0){
				return;
			}
			if(tab){
				toggleTab(tab);
			}
		}
		
		public function get tabGap():Number
		{
			return _tabGap;
		}
		
		public function set tabGap(value:Number):void
		{
			_tabGap = value;
		}
		
		public function get maxVisibleTabCount():int
		{
			return _maxVisibleTabCount;
		}
		
		public function set maxVisibleTabCount(value:int):void
		{
			_maxVisibleTabCount = value;
		}
		
		public function get titleButtonFactory():Class
		{
			return _titleButtonFactory;
		}
		
		public function set titleButtonFactory(value:Class):void
		{
			_titleButtonFactory = value;
		}
		
		public function expandAll():void
		{
			for each(var tab:Tab in tabList){
				expandTab(tab);
			}
			relayout();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function collapseAll():void
		{
			for each(var tab:Tab in tabList){
				collapseTab(tab);
			}
			relayout();
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}