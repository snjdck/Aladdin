package snjdck.gpu.render.instance
{
	import snjdck.gpu.asset.GpuIndexBuffer;

	internal class QuadIndexData
	{
		private const indexData:Vector.<uint> = new Vector.<uint>();
		private var indexBuffer:GpuIndexBuffer;
		private var maxQuadCount:int;
		
		public function QuadIndexData(){}
		
		public function getGpuData(quadCount:int):GpuIndexBuffer
		{
			if(maxQuadCount < quadCount){
				adjustData(quadCount);
				maxQuadCount = quadCount;
				if(indexBuffer != null)
					indexBuffer.dispose();
				indexBuffer = new GpuIndexBuffer(indexData.length);
				indexBuffer.upload(indexData);
			}
			return indexBuffer;
		}
		
		private function adjustData(quadCount:int):void
		{
			var offset:int = indexData.length;
			indexData.length = quadCount * 6;
			for(var i:int=maxQuadCount; i<quadCount; ++i){
				var index:int = i << 2;
				indexData[offset++] = index;
				indexData[offset++] = index + 1;
				indexData[offset++] = index + 3;
				indexData[offset++] = index;
				indexData[offset++] = index + 3;
				indexData[offset++] = index + 2;
			}
		}
	}
}