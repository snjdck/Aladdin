package ui.list
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.signals.ISignal;
	
	import ui.Slider;
	
	public class ScrollList extends Sprite implements IList
	{
		private var _maxVisibleItems:int;
		private var _firstVisibleItemIndex:int;
		private var _listData:Array;
		
		private var _list:List;
		private var _scrollBar:Slider;
		
		public function ScrollList()
		{
			scrollBar.addEventListener(Event.SCROLL, __onScroll);
			addEventListener(MouseEvent.MOUSE_WHEEL, __onMouseWheel);
		}
		
		public function get scrollBar():Slider
		{
			return _scrollBar;
		}
		/*
		override protected function createChildren():void
		{
			super.createChildren();
			
			_list = new List();
			_scrollBar = new ScrollBar();
			
			$_addChild(_list);
			$_addChild(scrollBar);
			
			scrollBar.x = _list.width;
			scrollBar.visible = false;
		}
		*/
		public function setValue(value:Array):void
		{
			_listData = value;
			scrollV = 0;
			updateScrollBar();
		}
		
		private function updateScrollBar():void
		{
			scrollBar.viewSize = maxVisibleItems;
			scrollBar.pageSize = numTotalItems;
			scrollBar.visible = scrollBar.canScroll();
			scrollBar.x = _list.width;
			scrollBar.height = _list.height;
		}
		
		public function get maxVisibleItems():int
		{
			return _maxVisibleItems > 0 ? _maxVisibleItems : int.MAX_VALUE;
		}
		
		public function set maxVisibleItems(value:int):void
		{
			_maxVisibleItems = value;
			updateScrollBar();
			scrollV = scrollV;
		}
		
		public function get scrollV():Number
		{
			return scrollBar.scrollV;
		}
		
		public function set scrollV(value:Number):void
		{
			scrollBar.scrollV = value;
		}
		
		public function get numTotalItems():Number
		{
			return _listData ? _listData.length : 0;
		}
		
		private function __onScroll(event:Event):void
		{
			var oldSelectedIndex:int = selectedIndex;
			var listDataToShow:Array;
			
			if(maxVisibleItems < numTotalItems){
				_firstVisibleItemIndex = Math.round((numTotalItems - maxVisibleItems) * scrollV);
				listDataToShow = _listData.slice(_firstVisibleItemIndex, _firstVisibleItemIndex+maxVisibleItems);
			}else{
				_firstVisibleItemIndex = 0;
				listDataToShow = _listData;
			}
			
			_list.setValue(listDataToShow);
			selectedIndex = oldSelectedIndex;
		}
		
		private function __onMouseWheel(event:MouseEvent):void
		{
			scrollBar.scroll(-event.delta);
		}
		
		public function clear():void
		{
			_listData = [];
			_list.clear();
		}
		
		public function getValue():Array
		{
			return _listData.slice();
		}
		
		public function get selectedData():*
		{
			return _listData[selectedIndex];
		}
		
		public function get selectedIndex():int
		{
			return _list.selectedIndex + _firstVisibleItemIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			_list.selectedIndex = value - _firstVisibleItemIndex;
		}
		
		public function get selectedSignal():ISignal
		{
			return _list.selectedSignal;
		}
		
		public function get labelField():String
		{
			return _list.labelField;
		}
		
		public function set labelField(value:String):void
		{
			_list.labelField = value;
		}
		
		public function get listItemFactory():Class
		{
			return _list.listItemFactory;
		}
		
		public function set listItemFactory(value:Class):void
		{
			_list.listItemFactory = value;
		}
		
		public function get numCols():int
		{
			return _list.numCols;
		}
		
		public function set numCols(value:int):void
		{
			_list.numCols = value;
		}
		
		public function get hGap():Number
		{
			return _list.hGap;
		}
		
		public function set hGap(value:Number):void
		{
			_list.hGap = value;
		}
		
		public function get vGap():Number
		{
			return _list.vGap;
		}
		
		public function set vGap(value:Number):void
		{
			_list.vGap = value;
		}
		
		public function getDisplayObject():DisplayObject
		{
			return this;
		}
	}
}