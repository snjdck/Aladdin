package snjdck.fileformat.ogre.support
{
	public class VertexBufferParam
	{
		public var data32PerVertex:uint;//每个顶点包含多少个数据
		public var data:Vector.<Number>;
		
		public function VertexBufferParam(data32PerVertex:uint)
		{
			this.data32PerVertex = data32PerVertex;
		}
	}
}