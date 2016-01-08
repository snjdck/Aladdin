package snjdck.gpu.render.instance
{
	internal class TrigVertexData extends BaseVertexData
	{
		private var data32perTrig:int;
		
		public function TrigVertexData()
		{
			super(4, 3);
			data32perTrig = 12;
		}
		
		override protected function adjustData(instanceCount:int):void
		{
			vertexData.length = instanceCount * data32perTrig;
			var offset:int = maxInstanceCount * data32perTrig;
			for(var i:int=maxInstanceCount; i<instanceCount; ++i){
				vertexData[offset   ] =
				vertexData[offset+5 ] =
				vertexData[offset+10] = 1;
				vertexData[offset+3 ] =
				vertexData[offset+7 ] =
				vertexData[offset+11] = i;
				offset += data32perTrig;
			}
		}
	}
}