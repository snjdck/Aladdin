package stdlib.knapsack
{
	import string.replace;

	public class Item implements IItem
	{
		private var _weight:uint;
		private var _price:Number;
		
		public function Item(weight:uint, price:Number)
		{
			this._weight = weight;
			this._price = price;
		}
		
		public function get weight():uint
		{
			return _weight;
		}
		
		public function get price():Number
		{
			return _price;
		}
		
		public function toString():String
		{
			return string.replace("[weight:${0},price:${1}]", [_weight, _price]);
		}
	}
}