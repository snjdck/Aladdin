package test
{
	import snjdck.gpu.asset.GpuVertexBuffer;

	public class VertexBuffer3DInfo
	{
		public var buffer:GpuVertexBuffer;
		public var offset:int;
		
		public function VertexBuffer3DInfo(buffer:GpuVertexBuffer, offset:int=0)
		{
			this.buffer = buffer;
			this.offset = offset;
		}
	}
}