package snjdck.gpu.render.instance
{
	import snjdck.gpu.asset.GpuIndexBuffer;

	internal class BaseIndexData
	{
		protected const indexData:Vector.<uint> = new Vector.<uint>();
		protected var maxInstanceCount:int;
		private var indexBuffer:GpuIndexBuffer;
		
		public function BaseIndexData(){}
		
		public function getGpuData(instanceCount:int):GpuIndexBuffer
		{
			if(maxInstanceCount < instanceCount){
				adjustData(instanceCount);
				maxInstanceCount = instanceCount;
				if(indexBuffer != null)
					indexBuffer.dispose();
				indexBuffer = new GpuIndexBuffer(indexData.length);
				indexBuffer.upload(indexData);
			}
			return indexBuffer;
		}
		
		virtual protected function adjustData(instanceCount:int):void
		{
		}
	}
}