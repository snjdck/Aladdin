package snjdck.gpu.render.instance
{
	import snjdck.gpu.asset.GpuVertexBuffer;

	internal class VertexData
	{
		static private const data32perVertex:int = 3;
		static private const data32perQuad:int = data32perVertex << 2;
		
		private const vertexData:Vector.<Number> = new Vector.<Number>();
		private var vertexBuffer:GpuVertexBuffer;
		private var maxQuadCount:int;
		
		public function VertexData(){}
		
		public function getGpuData(quadCount:int):GpuVertexBuffer
		{
			if(maxQuadCount < quadCount){
				adjustData(quadCount);
				maxQuadCount = quadCount;
				if(vertexBuffer != null)
					vertexBuffer.dispose();
				vertexBuffer = new GpuVertexBuffer(quadCount << 2, data32perVertex);
				vertexBuffer.upload(vertexData);
			}
			return vertexBuffer;
		}
		
		private function adjustData(quadCount:int):void
		{
			vertexData.length = quadCount * data32perQuad;
			var offset:int = maxQuadCount * data32perQuad;
			for(var i:int=maxQuadCount; i<quadCount; ++i){
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