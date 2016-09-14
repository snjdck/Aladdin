package snjdck.g2d.impl
{
	import flash.geom.Rectangle;
	
	import snjdck.gpu.render.instance.IInstanceData;
	
	internal class OpaqueAreaDrawer implements IInstanceData
	{
		private var areaList:Vector.<Rectangle>;
		
		public function OpaqueAreaDrawer(areaList:Vector.<Rectangle>)
		{
			this.areaList = areaList;
		}
		
		public function get numRegisterPerInstance():int
		{
			return 1;
		}
		
		public function get numRegisterReserved():int
		{
			return 4;
		}
		
		public function initConstData(constData:Vector.<Number>):void
		{
			constData[14] = 0;
			constData[15] = 1;
		}
		
		public function updateConstData(constData:Vector.<Number>, instanceOffset:int, instanceCount:int):void
		{
			var offset:int = 16;
			for(var i:int=0; i<instanceCount; ++i){
				var rect:Rectangle = areaList[instanceOffset+i];
				constData[offset++] = rect.width;
				constData[offset++] = rect.height;
				constData[offset++] = rect.x;
				constData[offset++] = rect.y;
			}
		}
	}
}