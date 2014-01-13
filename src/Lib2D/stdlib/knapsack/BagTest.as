package stdlib.knapsack
{
	public class BagTest
	{
		static private var itemList:Array = [new Item(3,4),new Item(4,5),new Item(5,6)];
		
		static public function run():void
		{
			Knapsack.ZeroOnePack(itemList, 10);
			trace(Knapsack.ZeroOnePack(makeData(77,92,22,22,29,87,50,46,99,90), 100) == 133);
			trace(Knapsack.ZeroOnePack(makeData(79,83,58,14,86,54,11,79,28,72,62,52,15,48,68,62), 200) == 334);
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