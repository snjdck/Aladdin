package snjdck.g2d.geom
{
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.render.instance.IInstanceData;
	import snjdck.gpu.render.instance.InstanceRender;

	internal class FillDrawer implements IInstanceData
	{
		private var polygon:Polygon;
		
		public function FillDrawer(polygon:Polygon)
		{
			this.polygon = polygon;
		}
		
		public function draw(context3d:GpuContext):void
		{
			context3d.program = AssetMgr.Instance.getProgram("g2d_polygon_fill");
			InstanceRender.Instance.drawTrig(context3d, this);
		}
		
		public function get numRegisterPerInstance():int
		{
			return 2;
		}
		
		public function get numInstances():int
		{
			var indices:Vector.<uint> = polygon.triangulate();
			return indices.length / 3;
		}
		
		public function initConstData(constData:Vector.<Number>):void
		{
			constData[14] = 0;
			constData[15] = 1;
		}
		
		public function updateConstData(constData:Vector.<Number>, instanceOffset:int, instanceCount:int):void
		{
			var indices:Vector.<uint> = polygon.triangulate();
			var vertexList:Vector.<Number> = polygon.vertexList;
			var indiceOffset:int = instanceOffset * 3;
			var offset:int = 16;
			for(var i:int=0; i<instanceCount; ++i){
				for(var j:int=0; j<3; ++j){
					var vertexOffset:int = indices[indiceOffset] << 1;
					constData[offset  ] = vertexList[vertexOffset];
					constData[offset+1] = vertexList[vertexOffset+1];
					++indiceOffset;
					offset += 2;
				}
				offset += 2;
			}
		}
	}
}