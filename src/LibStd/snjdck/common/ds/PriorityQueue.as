package snjdck.common.ds
{
	/**
	 * 优先级高的先出列
	 */
	final public class PriorityQueue
	{
		/** 优先级从低到高排列 */
		private var dock:Array;
		private var keyField:String;
		
		public function PriorityQueue(keyField:String)
		{
			this.keyField = keyField;
			this.dock = [];
		}
		
		public function push(item:Object):void
		{
			for(var i:int=dock.length-1; i>=0; --i)
			{
				var testItem:Object = dock[i];
				if(item[keyField] > testItem[keyField]){
					dock.splice(i+1, item);
					return;
				}
			}
			dock.unshift(item);
		}
		
		public function shift():*
		{
			return dock.pop();
		}
		
		public function clone():PriorityQueue
		{
			var copy:PriorityQueue = new PriorityQueue(keyField);
			copy.dock.push.apply(null, dock);
			return copy;
		}
		
		public function isEmpty():Boolean
		{
			return 0 == dock.length;
		}
	}
}