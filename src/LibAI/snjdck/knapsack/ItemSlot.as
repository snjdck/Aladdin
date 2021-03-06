package snjdck.knapsack
{
	import string.replace;

	public class ItemSlot
	{
		static public function CreateList(size:int):Vector.<ItemSlot>
		{
			var slotLst:Vector.<ItemSlot> = new Vector.<ItemSlot>(size, true);
			for(var i:int=0; i<slotLst.length; ++i){
				slotLst[i] = new ItemSlot();
			}
			return slotLst;
		}
		
		private var _itemList:Array;
		private var _price:Number;
		
		public function ItemSlot()
		{
			_itemList = [];
			_price = 0;
		}
		
		public function clear():void
		{
			_itemList.length = 0;
			_price = 0;
		}
		
		public function addItem(item:IItem):void
		{
			_itemList.push(item);
			_price += item.price;
		}
		
		public function get price():Number
		{
			return _price;
		}
		
		public function copyFrom(target:ItemSlot):void
		{
			_itemList = target._itemList.slice();
			_price = target._price;
		}
		
		public function toString():String
		{
			return string.replace("price:${1},itemList:[${0}]", [_itemList, _price]);
		}
	}
}