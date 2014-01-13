package stdlib.knapsack
{
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
	}
}