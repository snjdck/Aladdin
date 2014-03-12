package snjdck.fileformat.ogre.support
{
	public class VertexElement
	{
		public var source:uint;
		public var type:uint;
		public var semantic:uint;
		public var offset:uint;
		
		public function VertexElement(source:uint, type:uint, semantic:uint, offset:uint)
		{
			this.source = source;
			this.type = type;
			this.semantic = semantic;
			this.offset = offset;
		}
	}
}