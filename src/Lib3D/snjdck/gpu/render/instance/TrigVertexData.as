package snjdck.gpu.render.instance
{
	internal class TrigVertexData extends BaseVertexData
	{
		private var data32perTrig:int;
		
		public function TrigVertexData()
		{
			super(1, 3);
			data32perTrig = 3;
		}
		
		override protected function adjustData(instanceCount:int):void
		{
			vertexData.length = instanceCount * data32perTrig;
			var offset:int = maxInstanceCount * data32perTrig;
			for(var i:int=maxInstanceCount; i<instanceCount; ++i){
				vertexData[offset  ] = i;
				vertexData[offset+1] = i;
				vertexData[offset+2] = i;
				offset += data32perTrig;
			}
		}
	}
}