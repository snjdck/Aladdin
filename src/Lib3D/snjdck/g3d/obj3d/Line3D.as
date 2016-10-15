package snjdck.g3d.obj3d
{
	import flash.geom.Vector3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.parser.Geometry;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.g3d.rendersystem.subsystems.RenderPriority;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.GpuColor;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.render.instance.IInstanceData;
	import snjdck.gpu.render.instance.InstanceRender;
	
	use namespace ns_g3d;
	
	public class Line3D extends Object3D implements IDrawUnit3D, IInstanceData
	{
		private const vertexList:Vector.<Number> = new Vector.<Number>();
		public const color:GpuColor = new GpuColor(0xFFFFFFFF);
		public var lineWidth:Number = 1;
		
		private var canRender:Boolean;
		
		public function Line3D()
		{
//			blendMode = BlendMode.NORMAL;
		}
		
		public function setPt(from:Vector3D, to:Vector3D):void
		{
			vertexList.push(
				from.x, from.y, from.z,
				to.x, to.y, to.z
			);
			canRender = true;
		}
		
		public function draw(context3d:GpuContext):void
		{
			color.copyTo(buffer);
			context3d.setFc(0, buffer);
			var constData:Vector.<Number> = InstanceRender.Instance.constData;
			worldTransform.copyRawDataTo(constData, Geometry.WORLD_MATRIX_OFFSET*4, true);
			InstanceRender.Instance.drawQuad(context3d, this, vertexList.length / 3);
		}
		
		static private const zAxis:Vector3D = new Vector3D();
		static private const buffer:Vector.<Number> = new Vector.<Number>(4, true);
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			if(canRender){
				collector.addItem(this, RenderPriority.LINE_3D);
			}
		}
		
		public function get numRegisterPerInstance():int
		{
			return 2;
		}
		
		public function get numRegisterReserved():int
		{
			return 8;
		}
		
		public function initConstData(constData:Vector.<Number>):void
		{
			constData[4] = lineWidth * 0.5;
			constData[6] = 0;
			constData[7] = 1;
		}
		
		public function updateConstData(constData:Vector.<Number>, instanceOffset:int, instanceCount:int):void
		{
			var vertexListLength:int = vertexList.length;
			var vertexOffset:int = instanceOffset * 3;
			var offset:int = 32;
			for(var i:int=0; i<instanceCount; ++i){
				constData[offset  ] = vertexList[vertexOffset];
				constData[offset+1] = vertexList[vertexOffset+1];
				constData[offset+2] = vertexList[vertexOffset+2];
				
				vertexOffset += 3;
				if(vertexOffset >= vertexListLength){
					vertexOffset = 0;
				}
				
				constData[offset+4] = vertexList[vertexOffset];
				constData[offset+5] = vertexList[vertexOffset+1];
				constData[offset+6] = vertexList[vertexOffset+2];
				
				offset += 8;
			}
		}
	}
}