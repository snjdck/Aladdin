package snjdck.gpu.asset
{
	import flash.display3D.Context3DBufferUsage;

	final public class GpuIndexBuffer extends GpuAsset
	{
		public function GpuIndexBuffer(numIndices:int, bufferUsage:String=Context3DBufferUsage.STATIC_DRAW)
		{
			super("createIndexBuffer", arguments);
		}
		
		public function upload(data:Vector.<uint>, count:int=-1):void
		{
			uploadImp("uploadFromVector", data, 0, (count >= 0 ? count : initParams[0]));
		}
	}
}