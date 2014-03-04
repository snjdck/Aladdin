package ui.tabedpane
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;

	internal class Tab
	{
		private var _title:Sprite;
		private var _component:Sprite;
		
		private var index:int;
		private var eventDispatch:IEventDispatcher;
		
		public function Tab(title:Sprite, component:Sprite, index:int, eventDispatch:IEventDispatcher)
		{
			this._title = title;
			this._component = component;
			this.index = index;
			this.eventDispatch = eventDispatch;
		}
		
		private function get parent():DisplayObjectContainer
		{
			return title.parent;
		}
		
		public function isContentShowing():Boolean
		{
			return component.parent == parent;
		}
		
		public function showContent():void
		{
			if(isContentShowing()){
				return;
			}
//			title.selected = true;
			parent.addChildAt(component, 0);
//			eventDispatch.dispatchEvent(new TabedPaneEvent(TabedPaneEvent.TAB_FOCUS_IN, index));
		}
		
		public function hideContent():void
		{
			if(isContentShowing() == false){
				return;
			}
//			title.selected = false;
			parent.removeChild(component);
//			eventDispatch.dispatchEvent(new TabedPaneEvent(TabedPaneEvent.TAB_FOCUS_OUT, index));
		}

		public function get title():Sprite
		{
			return _title;
		}

		public function get component():Sprite
		{
			return _component;
		}
	}
}