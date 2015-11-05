package snjdck.model3d
{
	public function mergeVertexUV(vertex:Vector.<Number>, uv:Vector.<Number>):Vector.<Number>
	{
		var count:int = uv.length >> 1;
		assert(count * 3 == vertex.length);
		var result:Vector.<Number> = new Vector.<Number>(count * 5, true);
		for(var i:int=0; i<count; ++i){
			var vOffset:int = 3 * i;
			var uOffset:int = i << 1;
			var offset:int = uOffset + vOffset;
			result[offset  ] = vertex[vOffset];
			result[offset+1] = vertex[vOffset+1];
			result[offset+2] = vertex[vOffset+2];
			result[offset+3] = uv[uOffset];
			result[offset+4] = uv[uOffset+1];
		}
		return result;
	}
}