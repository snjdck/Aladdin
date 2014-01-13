package snjdck.g3d.asset.impl
{
	import snjdck.g3d.asset.IGpuVertexBuffer;

	final internal class GpuVertexBuffer extends GpuAsset implements IGpuVertexBuffer
	{
		public function GpuVertexBuffer(numVertices:int, data32PerVertex:int)
		{
			super("createVertexBuffer", arguments);
		}
		
		public function upload(data:Vector.<Number>, numVertices:int=-1):void
		{
			uploadImp("uploadFromVector", data, 0, (numVertices >= 0 ? numVertices : initParams[0]));
		}
	}
}