package snjdck.gpu.render.instance
{
	final public class EmptyInstanceData implements IInstanceData
	{
		static public const Instance:IInstanceData = new EmptyInstanceData();
		
		public function EmptyInstanceData()
		{
		}
		
		public function get numRegisterReserved():int
		{
			return 0;
		}
		
		public function get numRegisterPerInstance():int
		{
			return 0;
		}
		
		public function initConstData(constData:Vector.<Number>):void
		{
		}
		
		public function updateConstData(constData:Vector.<Number>, instanceOffset:int, instanceCount:int):void
		{
		}
	}
}