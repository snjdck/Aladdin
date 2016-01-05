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
				vertexData[offset+2] = i;
				offset += data32perVertex;
				vertexData[offset] = 1;
				vertexData[offset+2] = i;
				offset += data32perVertex;
				vertexData[offset+1] = 1;
				vertexData[offset+2] = i;
				offset += data32perVertex;
				vertexData[offset] = 1;
				vertexData[offset+1] = 1;
				vertexData[offset+2] = i;
				offset += data32perVertex;
			}
		}
	}
}