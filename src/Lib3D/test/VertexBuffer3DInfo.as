package
{
	import flash.display3D.VertexBuffer3D;

	public class VertexBuffer3DInfo
	{
		public var buffer:VertexBuffer3D;
		public var offset:int;
		
		public function VertexBuffer3DInfo(buffer:VertexBuffer3D, offset:int=0)
		{
			this.buffer = buffer;
			this.offset = offset;
		}
	}
}