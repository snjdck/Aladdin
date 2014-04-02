package stdlib.knapsack
{
	public class Knapsack
	{
		static public function ZeroOnePack(itemList:Array, capacity:uint):ItemSlot
		{
			return Pack(itemList, capacity, onZeroOne);
		}
		
		static public function UnboundedPack(itemList:Array, capacity:uint):ItemSlot
		{
			return Pack(itemList, capacity, onUnbounded);
		}
		
		static private function Pack(itemList:Array, capacity:uint, strategy:Function):ItemSlot
		{
			if(null == itemList || itemList.length < 1){
				return null;
			}
			
			const m:Vector.<ItemSlot> = createSlotList(capacity+1);
			
			for each(var item:IItem in itemList){
				strategy(item, capacity, m);
			}
			
			return m[capacity];
		}
		
		static private function onZeroOne(item:IItem, capacity:uint, m:Vector.<ItemSlot>):void
		{
			for(var totalWeight:int=capacity; totalWeight>=item.weight; totalWeight--)
			{
				var itemSlotNotUse:ItemSlot = m[totalWeight];
				var itemSlotUse:ItemSlot = m[totalWeight-item.weight];
				if(itemSlotNotUse.price < itemSlotUse.price + item.price){
					itemSlotNotUse.copyFrom(itemSlotUse);
					itemSlotNotUse.addItem(item);
				}
			}
		}
		
		static private function onUnbounded(item:IItem, capacity:uint, m:Vector.<ItemSlot>):void
		{
			for(var totalWeight:int=item.weight; totalWeight<=capacity; totalWeight++)
			{
				var itemSlotNotUse:ItemSlot = m[totalWeight];
				var itemSlotUse:ItemSlot = m[totalWeight-item.weight];
				if(itemSlotNotUse.price < itemSlotUse.price + item.price){
					itemSlotNotUse.copyFrom(itemSlotUse);
					itemSlotNotUse.addItem(item);
				}
			}
		}
		
		static private function createSlotList(size:int):Vector.<ItemSlot>
		{
			var slotLst:Vector.<ItemSlot> = new Vector.<ItemSlot>(size, true);
			for(var i:int=0; i<slotLst.length; ++i){
				slotLst[i] = new ItemSlot();
			}
			return slotLst;
		}
	}
}