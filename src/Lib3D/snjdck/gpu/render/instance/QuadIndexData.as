package snjdck.gpu.render.instance
{
	import flash.geom.d3.extendQuadListIndices;

	internal class QuadIndexData extends BaseIndexData
	{
		public function QuadIndexData(){}
		
		override protected function adjustData(instanceCount:int):void
		{
			indexData.length = instanceCount * 6;
			extendQuadListIndices(maxInstanceCount, instanceCount, indexData);
		}
	}
}