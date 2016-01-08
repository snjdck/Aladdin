package snjdck.gpu.render.instance
{
	internal class TrigIndexData extends BaseIndexData
	{
		public function TrigIndexData(){}
		
		override protected function adjustData(instanceCount:int):void
		{
			var offset:int = indexData.length;
			indexData.length = instanceCount * 3;
			for(var i:int=indexData.length-1; i>=offset; --i){
				indexData[i] = i;
			}
		}
	}
}