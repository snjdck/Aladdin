package flash.ds
{
	import array.has;

	/** 最小二叉堆 */
	final public class BinHeap
	{
		private var keyField:String;
		private var dock:Array;
		
		public function BinHeap(keyField:String)
		{
			this.keyField = keyField;
			this.dock = [];
		}
		
		public function push(item:Object):void
		{
			var index:int = dock.length;
			dock[index] = item;
			bubbleUp(index);
		}
		
		public function shift():*
		{
			var item:Object;
			
			if(dock.length > 2){
				item = dock[0];
				dock[0] = dock.pop();
				bubbleDown(0);
			}else{
				item = dock.shift();
			}
			
			return item;
		}
		
		public function update(item:Object, newValue:Number=NaN):void
		{
			var index:int = dock.indexOf(item);
			
			if(-1 == index){
				return;
			}
			
			if(isNaN(newValue)){
				bubbleDown(index);
				bubbleUp(index);
				return;
			}
			
			var oldValue:Number = item[keyField];
			item[keyField] = newValue;
			
			if(newValue < oldValue){
				bubbleUp(index);
			}else if(newValue > oldValue){
				bubbleDown(index);
			}
		}
		
		private function bubbleUp(fromIndex:int):void
		{
			var childIndex:int = fromIndex;
			var parentIndex:int;
			
			while(childIndex > 0){
				parentIndex = (childIndex - 1) >> 1;
				if(needSwap(parentIndex, childIndex) == false){
					break;
				}
				swap(childIndex, parentIndex);
				childIndex = parentIndex;
			}
		}
		
		private function bubbleDown(fromIndex:int):void
		{
			const maxLength:int = dock.length;
			
			var parentIndex:int = fromIndex;
			var leftChildIndex:int;
			var rightChildIndex:int;
			var childIndex:int;
			
			while(true){
				leftChildIndex = (parentIndex << 1) + 1;
				if(leftChildIndex >= maxLength){
					break;
				}
				rightChildIndex = leftChildIndex + 1;
				childIndex = ((rightChildIndex < maxLength) && needSwap(leftChildIndex, rightChildIndex)) ? rightChildIndex : leftChildIndex;
				if(needSwap(parentIndex, childIndex) == false){
					break;
				}
				swap(parentIndex, childIndex);
				parentIndex = childIndex;
			}
		}
		
		private function needSwap(parentIndex:int, childIndex:int):Boolean
		{
			return dock[parentIndex][keyField] > dock[childIndex][keyField];
		}
		
		private function swap(index1:int, index2:int):void
		{
			var t:Object = dock[index1];
			dock[index1] = dock[index2];
			dock[index2] = t;
		}
		
		public function clear():void
		{
			dock.splice(0);
		}
		
		public function isEmpty():Boolean
		{
			return 0 == dock.length;
		}
		
		public function has(item:Object):Boolean
		{
			return array.has(dock, item);
		}
		
		public function toString():String
		{
			return dock.toString();
		}
	}
}