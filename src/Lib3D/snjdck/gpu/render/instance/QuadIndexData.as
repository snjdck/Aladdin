package snjdck.gpu.render.instance
{
	internal class QuadIndexData extends BaseIndexData
	{
		public function QuadIndexData(){}
		
		override protected function adjustData(instanceCount:int):void
		{
			var offset:int = indexData.length;
			indexData.length = instanceCount * 6;
			for(var i:int=maxInstanceCount; i<instanceCount; ++i){
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