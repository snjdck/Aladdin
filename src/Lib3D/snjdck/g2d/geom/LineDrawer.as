package snjdck.g2d.geom
{
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.render.instance.IInstanceData;
	import snjdck.gpu.render.instance.InstanceRender;

	internal class LineDrawer implements IInstanceData
	{
		private var polygon:Polygon;
		
		public function LineDrawer(polygon:Polygon)
		{
			this.polygon = polygon;
		}
		
		public function draw(context3d:GpuContext):void
		{
			context3d.program = AssetMgr.Instance.getProgram("g2d_polygon_line");
			InstanceRender.Instance.drawQuad(context3d, this);
		}
		
		public function get numRegisterPerInstance():int
		{
			return 1;
		}
		
		public function get numInstances():int
		{
			return polygon.vertexCount;
		}
		
		public function initConstData(constData:Vector.<Number>):void
		{
			constData[12] = 0.5 * polygon.lineWidth;
			constData[14] = 0;
			constData[15] = 1;
		}
		
		public function updateConstData(constData:Vector.<Number>, instanceOffset:int, instanceCount:int):void
		{
			var vertexList:Vector.<Number> = polygon.vertexList;
			var vertexListLength:int = vertexList.length;
			var vertexOffset:int = instanceOffset << 1;
			var offset:int = 16;
			for(var i:int=0; i<instanceCount; ++i){
				constData[offset  ] = vertexList[vertexOffset];
				constData[offset+1] = vertexList[vertexOffset+1];
				
				vertexOffset += 2;
				if(vertexOffset >= vertexListLength){
					vertexOffset = 0;
				}
				
				constData[offset+2] = vertexList[vertexOffset];
				constData[offset+3] = vertexList[vertexOffset+1];
				
				offset += 4;
			}
		}
	}
}