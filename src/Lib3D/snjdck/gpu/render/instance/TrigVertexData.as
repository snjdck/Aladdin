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
			var offset:int = vertexData.length;
			vertexData.length = instanceCount * data32perTrig;
			for(var i:int=vertexData.length-1; i>=offset; --i){
				vertexData[i] = i;
			}
		}
	}
}