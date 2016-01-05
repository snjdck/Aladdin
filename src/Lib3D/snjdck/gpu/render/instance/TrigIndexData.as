package snjdck.gpu.render.instance
{
	import snjdck.gpu.asset.GpuIndexBuffer;

	internal class TrigIndexData
	{
		private const indexData:Vector.<uint> = new Vector.<uint>();
		private var indexBuffer:GpuIndexBuffer;
		private var maxTrigCount:int;
		
		public function TrigIndexData(){}
		
		public function getGpuData(trigCount:int):GpuIndexBuffer
		{
			if(maxTrigCount < trigCount){
				adjustData(trigCount);
				maxTrigCount = trigCount;
				if(indexBuffer != null)
					indexBuffer.dispose();
				indexBuffer = new GpuIndexBuffer(indexData.length);
				indexBuffer.upload(indexData);
			}
			return indexBuffer;
		}
		
		private function adjustData(trigCount:int):void
		{
			var offset:int = indexData.length;
			indexData.length = trigCount * 3;
			for(var i:int=maxTrigCount; i<trigCount; ++i){
				indexData[offset] = offset; ++offset;
				indexData[offset] = offset; ++offset;
				indexData[offset] = offset; ++offset;
			}
		}
	}
}