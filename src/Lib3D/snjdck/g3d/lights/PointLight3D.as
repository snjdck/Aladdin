package snjdck.g3d.lights
{
	import flash.display3D.Context3DTextureFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import matrix44.extractPosition;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.cameras.Camera3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.rendersystem.RenderSystem;
	import snjdck.g3d.rendersystem.subsystems.RenderPass;
	import snjdck.gpu.CubeSide;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.render.ScreenDrawer;
	
	public class PointLight3D extends Object3D implements ILight3D
	{
		static public const SHADOW_BIAS:Number = 0.0022;
		static public const SHADOW_MAP_SIZE:int = 1024;
		
		private var shadowMap:GpuRenderTarget;
		private const constVc:Vector.<Number> = new Vector.<Number>(20);
		private const constFc:Vector.<Number> = new Vector.<Number>(32);
		
		public function PointLight3D()
		{
			constVc[0] = constVc[1] = 1;
			constVc[2] = Camera3D.zRange;
			
			shadowMap = new GpuRenderTarget(SHADOW_MAP_SIZE, SHADOW_MAP_SIZE, Context3DTextureFormat.BGRA, true);
			shadowMap.enableDepthAndStencil = true;
			
			var matrix:Matrix3D;
			
			matrix = new Matrix3D();
			matrix.appendRotation(-90, Vector3D.Y_AXIS);
			matrixList[CubeSide.POSITIVE_X] = matrix;
			matrix = new Matrix3D();
			matrix.appendRotation(90, Vector3D.Y_AXIS);
			matrixList[CubeSide.NEGATIVE_X] = matrix;
			
			matrix = new Matrix3D();
			matrix.appendRotation(90, Vector3D.X_AXIS);
			matrixList[CubeSide.POSITIVE_Y] = matrix;
			matrix = new Matrix3D();
			matrix.appendRotation(-90, Vector3D.X_AXIS);
			matrixList[CubeSide.NEGATIVE_Y] = matrix;
			
			matrixList[CubeSide.POSITIVE_Z] = new Matrix3D();
			matrix = new Matrix3D();
			matrix.appendRotation(180, Vector3D.X_AXIS);
			matrixList[CubeSide.NEGATIVE_Z] = matrix;
			
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			collector.addLight(this);
		}
		
		public function drawShadowMap(context3d:GpuContext, render3d:RenderSystem):void
		{
			extractPosition(worldTransform, offset);
			for(var i:int=0; i<6; ++i){
				var matrix:Matrix3D = matrixList[i];
				matrix.copyRawDataTo(constVc, 4, true);
				constVc[16] = offset.x;
				constVc[17] = offset.y;
				constVc[18] = offset.z;
				context3d.setVc(0, constVc, 5);
				shadowMap.setRenderToSelfAndClear(context3d, i);
				render3d.render(context3d, RenderPass.DEPTH_PASS);
			}
		}
		
		public function drawLight(context3d:GpuContext, cameraTransform:Matrix3D):void
		{
			context3d.program = AssetMgr.Instance.getProgram("point_light_pass");
			context3d.setTextureAt(1, shadowMap);
			context3d.setFc(0, constFc, 7);
			ScreenDrawer.Draw(context3d);
		}
		
		private const matrixList:Array = [];
		
//		static private const matrix:Matrix3D = new Matrix3D();
		static private const offset:Vector3D = new Vector3D();
	}
}