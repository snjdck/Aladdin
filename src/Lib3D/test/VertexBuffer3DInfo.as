package test
{
	import flash.display3D.Context3D;
	
	import snjdck.gpu.asset.GpuVertexBuffer;

	public class VertexBuffer3DInfo
	{
		private var buffer:GpuVertexBuffer;
		private var format:String;
		private var offset:int;
		
		public function VertexBuffer3DInfo(buffer:GpuVertexBuffer, format:String, offset:int)
		{
			this.buffer = buffer;
			this.offset = offset;
			this.format = format;
		}
		
		public function assertFormatEqual(other:String):void
		{
			assert(format == other);
		}
		
		public function setVertexBufferAt(context3d:Context3D, index:int):void
		{
			context3d.setVertexBufferAt(index, buffer.getRawGpuAsset(context3d), offset, format);
		}
	}
}