package stdlib.knapsack
{
	public class Knapsack
	{
		static public function ZeroOnePack(itemList:Array, capacity:uint):int
		{
			return Pack(itemList, capacity, onZeroOne);
		}
		
		static public function UnboundedPack(itemList:Array, capacity:uint):int
		{
			return Pack(itemList, capacity, onUnbounded);
		}
		
		static private function Pack(itemList:Array, capacity:uint, strategy:Function):uint
		{
			if(null == itemList || itemList.length < 1){
				return 0;
			}
			
			const m:Vector.<int> = new Vector.<int>(capacity+1, true);
			
			for each(var item:IItem in itemList){
				strategy(item, capacity, m);
			}
			
			return m[capacity];
		}
		
		static private function onZeroOne(item:IItem, capacity:uint, m:Vector.<int>):void
		{
			for(var totalWeight:int=capacity; totalWeight>=item.weight; totalWeight--)
			{
				const valueOnUse:Number = m[totalWeight-item.weight] + item.price;
				if(valueOnUse > m[totalWeight]){
					m[totalWeight] = valueOnUse;
				}
			}
		}
		
		static private function onUnbounded(item:IItem, capacity:uint, m:Vector.<int>):void
		{
			for(var totalWeight:int=item.weight; totalWeight<=capacity; totalWeight++)
			{
				const valueOnUse:Number = m[totalWeight-item.weight] + item.price;
				if(valueOnUse > m[totalWeight]){
					m[totalWeight] = valueOnUse;
				}
			}
		}
	}
}