package snjdck.g3d.render
{
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.pickup.RayCastStack;
	import snjdck.g3d.pickup.RayTestInfo;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.asset.helper.AssetMgr;
	import snjdck.gpu.asset.helper.ShaderName;
	
	use namespace ns_g3d;

	public class Render3D
	{
		private const collector:DrawUnitCollector3D = new DrawUnitCollector3D();
		
		private const rayCastStack:RayCastStack = new RayCastStack();
		
		private var gpuVertexBuffer:GpuVertexBuffer;
		private var gpuIndexBuffer:GpuIndexBuffer;
		private var isGpuBufferInited:Boolean;
		
		public function Render3D(){}
		
		public function draw(scene3d:Object3D, context3d:GpuContext):void
		{
			collector.clear();
			scene3d.collectDrawUnit(collector);
			collector.root = scene3d;
			
			const hasOpaqueDrawUnits:Boolean = collector.opaqueList.length > 0;
			const hasBlendDrawUnits:Boolean = collector.blendList.length > 0;
			
			if(!(hasOpaqueDrawUnits || hasBlendDrawUnits)){
				return;
			}
			
			collector.drawBegin();
			
			for each(var camera3d:CameraUnit3D in collector.cameraList){
				camera3d.render(this, collector, context3d);
			}
		}
		
		public function pickup(screenX:Number, screenY:Number, result:Vector.<RayTestInfo>):void
		{
			for each(var camera3d:CameraUnit3D in collector.cameraList)
			{
				if(camera3d.mouseEnabled && camera3d.viewport.contains(screenX, screenY)){
					camera3d.getSceneRay(screenX, screenY, rayCastStack.ray);
					collector.root.hitTest(rayCastStack, result);
				}
			}
		}
		
		public function drawQuad(context3d:GpuContext, worldMatrix:Matrix3D, texture:IGpuTexture):void
		{
			initGpuBuffer(context3d);
			
			context3d.program = AssetMgr.Instance.getProgram(ShaderName.PROJECT_TEXTURE);
			context3d.texture = texture;
			context3d.blendMode = BlendMode.NORMAL;
			
			var scaleX:Number = 1;
			var scaleY:Number = 1;
			var offsetX:Number = 0;
			var offsetY:Number = 0;
			
			constData[0] =  0.5 / scaleX;
			constData[1] = -0.5 / scaleY;
			constData[2] = (0.5 - offsetX) / scaleX;
			constData[3] = (0.5 - offsetY) / scaleY;
			
			context3d.setVcM(DrawUnit3D.WORLD_MATRIX_OFFSET, worldMatrix);
			context3d.setVc(DrawUnit3D.BONE_MATRIX_OFFSET, constData, 1);
			context3d.setVertexBufferAt(0, gpuVertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3d.drawTriangles(gpuIndexBuffer);
		}
		
		private function initGpuBuffer(context3d:GpuContext):void
		{
			if(isGpuBufferInited){
				return;
			}
			isGpuBufferInited = true;
			
			gpuVertexBuffer = new GpuVertexBuffer(4, 2);
			gpuVertexBuffer.upload(new <Number>[-0.5, 0.5, 0.5, 0.5, 0.5, -0.5, -0.5, -0.5]);
			
			gpuIndexBuffer = new GpuIndexBuffer(6);
			gpuIndexBuffer.upload(new <uint>[0,1,2,0,2,3]);
		}
		
		static private const constData:Vector.<Number> = new Vector.<Number>();
	}
}