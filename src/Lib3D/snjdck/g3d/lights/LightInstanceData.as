package snjdck.g3d.lights
{
	import snjdck.gpu.render.instance.IInstanceData;
	
	public class LightInstanceData implements IInstanceData
	{
		public function LightInstanceData()
		{
		}
		
		public function get numRegisterPerInstance():int
		{
			return 0;
		}
		
		public function get numRegisterReserved():int
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