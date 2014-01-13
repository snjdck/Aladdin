package snjdck.g3d.asset.impl
{
	import snjdck.g3d.asset.IGpuIndexBuffer;

	final internal class GpuIndexBuffer extends GpuAsset implements IGpuIndexBuffer
	{
		public function GpuIndexBuffer(numIndices:int)
		{
			super("createIndexBuffer", arguments);
		}
		
		public function upload(data:Vector.<uint>, count:int=-1):void
		{
			uploadImp("uploadFromVector", data, 0, (count >= 0 ? count : initParams[0]));
		}
	}
}