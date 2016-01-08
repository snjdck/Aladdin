package snjdck.gpu.render.instance
{
	internal class QuadVertexData extends BaseVertexData
	{
		private var data32perQuad:int;
		
		public function QuadVertexData()
		{
			super(3, 4);
			data32perQuad = 12;
		}
		
		override protected function adjustData(instanceCount:int):void
		{
			vertexData.length = instanceCount * data32perQuad;
			var offset:int = maxInstanceCount * data32perQuad;
			for(var i:int=maxInstanceCount; i<instanceCount; ++i){
				vertexData[offset+3 ] =
				vertexData[offset+7 ] =
				vertexData[offset+9 ] =
				vertexData[offset+10] = 1;
				vertexData[offset+2 ] =
				vertexData[offset+5 ] =
				vertexData[offset+8 ] =
				vertexData[offset+11] = i;
				offset += data32perQuad;
			}
		}
	}
}