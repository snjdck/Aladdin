package snjdck.gpu.render.instance
{
	import snjdck.gpu.asset.GpuVertexBuffer;

	internal class TrigVertexData
	{
		static private const data32perVertex:int = 1;
		static private const data32perTrig:int = data32perVertex * 3;
		
		private const vertexData:Vector.<Number> = new Vector.<Number>();
		private var vertexBuffer:GpuVertexBuffer;
		private var maxTrigCount:int;
		
		public function TrigVertexData(){}
		
		public function getGpuData(trigCount:int):GpuVertexBuffer
		{
			if(maxTrigCount < trigCount){
				adjustData(trigCount);
				maxTrigCount = trigCount;
				if(vertexBuffer != null)
					vertexBuffer.dispose();
				vertexBuffer = new GpuVertexBuffer(trigCount * 3, data32perVertex);
				vertexBuffer.upload(vertexData);
			}
			return vertexBuffer;
		}
		
		private function adjustData(trigCount:int):void
		{
			vertexData.length = trigCount * data32perTrig;
			var offset:int = maxTrigCount * data32perTrig;
			for(var i:int=maxTrigCount; i<trigCount; ++i){
				vertexData[offset  ] = i;
				vertexData[offset+1] = i;
				vertexData[offset+2] = i;
				offset += data32perTrig;
			}
		}
	}
}