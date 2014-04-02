package snjdck
{
	import stdlib.knapsack.Knapsack;

	public class BagTest
	{
		static private var itemList:Array;
		
		static public function run():void
		{
			itemList = [new Item(3,4),new Item(4,5),new Item(5,6)];
			trace(Knapsack.ZeroOnePack(itemList, 10));
			trace(Knapsack.ZeroOnePack(makeData(77,92,22,22,29,87,50,46,99,90), 100), 133);
			trace(Knapsack.ZeroOnePack(makeData(79,83,58,14,86,54,11,79,28,72,62,52,15,48,68,62), 200), 334);
		}
		
		static private function makeData(...args):Array
		{
			var result:Array = [];
			
			while(args.length > 0){
				result.push(new Item(args.shift(), args.shift()));
			}
			
			return result;
		}
		
		public function BagTest()
		{
		}
	}
}

import stdlib.knapsack.IItem;

import string.replace;

class Item implements IItem
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