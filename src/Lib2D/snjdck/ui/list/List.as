package snjdck.ui.list
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.signals.ISignal;
	import flash.signals.Signal;
	
	public class List extends Sprite implements IList
	{
		private const _selectedSignal:Signal = new Signal();
		
		private const listItemRefs:Array = [];
		
		private var listData:Array;
		private var _selectedIndex:int = -1;
		
		private var _labelField:String;
		
		private var _listItemFactory:Class;
		private var _numCols:int = 1;
		private var _hGap:Number = 0;
		private var _vGap:Number = 0;
		
		public function List()
		{
			addEventListener(MouseEvent.CLICK, __onItemClick);
		}
		
		public function clear():void
		{
			setValue(null);
		}
		
		public function setValue(value:Array):void
		{
			setFocusItem(null);
			listData = value || [];
			adjustItemAmount(listData.length);
			setValueImpl(listData);
		}
		
		public function getValue():Array
		{
			return listData.slice();
		}
		
		private function getListItemCount():int
		{
			return listData ? listData.length : 0;
		}
		
		private function adjustItemAmount(amount:int):void
		{
			while(listItemRefs.length < amount){
				const index:int = listItemRefs.length;
				listItemRefs[index] = createListItem();
				relayoutImp(index);
			}
		}
		
		private function setValueImpl(valueList:Array):void
		{
			for(var i:int=listItemRefs.length-1; i>=0; i--){
				const listItem:ListItem = listItemRefs[i];
				if(i < valueList.length){
					listItem.data = valueList[i];
					if(!contains(listItem)){
						addChild(listItem);
					}
				}else if(contains(listItem)){
					removeChild(listItem);
				}
			}
		}
		
		private var focusItem:ListItem;
		private var layerIndex:int;
		
		private function setFocusItem(target:ListItem):void
		{
			if(focusItem == target){
				return;
			}
			if(focusItem){
				swapChildrenAt(layerIndex, numChildren-1);
				focusItem.onFocusOut();
			}
			focusItem = target;
			if(focusItem){
				layerIndex = getChildIndex(focusItem);
				swapChildrenAt(layerIndex, numChildren-1);
				focusItem.onFocusIn();
			}
		}
		
		public function setFocusItemAt(index:int):void
		{
			if(index < 0){
				setFocusItem(null);
			}else if(index >= getListItemCount()){
				setFocusItem(null);
			}else{
				setFocusItem(listItemRefs[index]);
			}
		}
		
		private function __onItemClick(evt:MouseEvent):void
		{
			selectedIndex = getListItemIndex(evt.stageX, evt.stageY);
		}
		
		private function getListItemIndex(px:Number, py:Number):int
		{
			for(var i:int=listItemRefs.length-1; i>=0; i--){
				const listItem:DisplayObject = listItemRefs[i];
				if(listItem.parent && listItem.hitTestPoint(px, py)){
					return i;
				}
			}
			return -1;
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			_selectedIndex = value;
			setFocusItemAt(value);
			if(selectedIndex >= 0){
				_selectedSignal.notify();
			}
		}
		
		public function get selectedData():*
		{
			return listData[selectedIndex];
		}
		
		public function get numCols():int
		{
			return _numCols;
		}

		public function set numCols(value:int):void
		{
			_numCols = Math.max(1, value);
			relayout();
		}
		
		public function get hGap():Number
		{
			return _hGap;
		}

		public function set hGap(value:Number):void
		{
			_hGap = value;
			relayout();
		}
		
		public function get vGap():Number
		{
			return _vGap;
		}

		public function set vGap(value:Number):void
		{
			_vGap = value;
			relayout();
		}
		
		private function createListItem():ListItem
		{
			if(null != listItemFactory){
				return new listItemFactory();
			}
			throw new Error("listItemFactory can't be null!");
		}

		public function get listItemFactory():Class
		{
			return _listItemFactory;
		}

		public function set listItemFactory(value:Class):void
		{
			_listItemFactory = value;
		}
		
		private function relayout():void
		{
			for(var index:int=listItemRefs.length-1; index >= 0; index--){
				relayoutImp(index);
			}
		}
		
		private function relayoutImp(index:int):void
		{
			var listItem:DisplayObject = listItemRefs[index];
			listItem.x = (listItem.width + hGap) * (index % numCols);
			listItem.y = (listItem.height + vGap) * int(index / numCols);
		}

		public function get labelField():String
		{
			return _labelField;
		}

		public function set labelField(value:String):void
		{
			_labelField = value;
		}

		public function get selectedSignal():ISignal
		{
			return _selectedSignal;
		}
		
		public function getDisplayObject():DisplayObject
		{
			return this;
		}
	}
}