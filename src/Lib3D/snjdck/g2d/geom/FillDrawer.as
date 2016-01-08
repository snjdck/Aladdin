package snjdck.g2d.geom
{
	import snjdck.gpu.GpuColor;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.render.instance.IInstanceData;
	import snjdck.gpu.render.instance.InstanceRender;

	internal class FillDrawer implements IInstanceData
	{
		public const color:GpuColor = new GpuColor(0xFFFF0000);
		
		private var vertexList:Vector.<Number>;
		private var indexList:Vector.<uint>;
		
		public function FillDrawer(vertexList:Vector.<Number>)
		{
			this.vertexList = vertexList;
		}
		
		public function draw(context3d:GpuContext, indexList:Vector.<uint>):void
		{
			this.indexList = indexList;
			context3d.program = AssetMgr.Instance.getProgram("g2d_polygon_fill");
			context3d.setFc(0, color.toVector(), 1);
			InstanceRender.Instance.drawTrig(context3d, this, indexList.length / 3);
		}
		
		public function get numRegisterPerInstance():int
		{
			return 2;
		}
		
		public function get numRegisterReserved():int
		{
			return 4;
		}
		
		public function initConstData(constData:Vector.<Number>):void
		{
			constData[14] = 0;
			constData[15] = 1;
		}
		
		public function updateConstData(constData:Vector.<Number>, instanceOffset:int, instanceCount:int):void
		{
			var indiceOffset:int = instanceOffset * 3;
			var offset:int = 16;
			for(var i:int=0; i<instanceCount; ++i){
				for(var j:int=0; j<3; ++j){
					var vertexOffset:int = indexList[indiceOffset] << 1;
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