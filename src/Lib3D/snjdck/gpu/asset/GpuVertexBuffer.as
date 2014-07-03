package snjdck.gpu.asset
{
	import flash.display3D.Context3DBufferUsage;

	final public class GpuVertexBuffer extends GpuAsset
	{
		public function GpuVertexBuffer(numVertices:int, data32PerVertex:int, bufferUsage:String=Context3DBufferUsage.STATIC_DRAW)
		{
			super("createVertexBuffer", arguments);
		}
		
		public function upload(data:Vector.<Number>, numVertices:int=-1):void
		{
			uploadImp("uploadFromVector", data, 0, (numVertices >= 0 ? numVertices : initParams[0]));
		}
	}
}