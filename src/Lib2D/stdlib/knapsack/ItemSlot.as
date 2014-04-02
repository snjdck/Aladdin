package stdlib.knapsack
{
	import string.replace;

	public class ItemSlot
	{
		private var _itemList:Array;
		private var _value:Number;
		
		public function ItemSlot()
		{
			_itemList = [];
			_value = 0;
		}
		
		public function addItem(item:IItem):void
		{
			_itemList.push(item);
			_value += item.price;
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		public function copyFrom(target:ItemSlot):void
		{
			_itemList = target._itemList.slice();
			_value = target._value;
		}
		
		public function toString():String
		{
			return string.replace("price:${1},itemList:[${0}]", [_itemList, _value]);
		}
	}
}