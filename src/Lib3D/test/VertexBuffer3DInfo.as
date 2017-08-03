package test
{
	import snjdck.gpu.asset.GpuVertexBuffer;

	public class VertexBuffer3DInfo
	{
		public var buffer:GpuVertexBuffer;
		public var offset:int;
		public var format:String;
		
		public function VertexBuffer3DInfo(buffer:GpuVertexBuffer, format:String, offset:int)
		{
			this.buffer = buffer;
			this.offset = offset;
			this.format = format;
		}
	}
}