package snjdck.g3d.lights
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.rendersystem.RenderSystem;
	import snjdck.g3d.rendersystem.subsystems.RenderPass;
	import snjdck.g3d.utils.RotationMatrix;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.render.ScreenDrawer;
	
	use namespace ns_g3d;
	
	public class DirectionLight3D extends Object3D implements ILight3D
	{
		static public const SHADOW_BIAS:Number = 0.0022;
		static public const SHADOW_MAP_SIZE:int = 2048;
		
		public var environmentBrightness:Number = 0.4;
		public var castShadows:Boolean;
		
		private var shadowMap:GpuRenderTarget;
		private const constVc:Vector.<Number> = new Vector.<Number>(20);
		private const constFc:Vector.<Number> = new Vector.<Number>(32);
		private const direction:Vector3D = new Vector3D(-Math.SQRT1_2, 0, -Math.SQRT1_2);
		private var viewMatrix:RotationMatrix;
		
		public function DirectionLight3D()
		{
			viewMatrix = new RotationMatrix(Vector3D.Z_AXIS, direction);
			
			constVc[0] = constVc[1] = SHADOW_MAP_SIZE >> 1;
			constVc[2] = Camera3D.zRange;
			constVc[3] = Camera3D.zNear;
			viewMatrix.transform.copyRawDataTo(constVc, 4, true);
			
			constFc[0] = constFc[1] = 0.5;
			constFc[2] = -Camera3D.zNear / Camera3D.zRange;
			constFc[3] = SHADOW_BIAS;
			constFc[6] = constFc[10] = Camera3D.zRange;
			constFc[8] = SHADOW_MAP_SIZE;
			constFc[9] = -SHADOW_MAP_SIZE;
			constFc[11] = 1;
			constFc[12] = -direction.x;
			constFc[13] = -direction.y;
			constFc[14] = -direction.z;
			
			shadowMap = new GpuRenderTarget(SHADOW_MAP_SIZE, SHADOW_MAP_SIZE);
			shadowMap.enableDepthAndStencil = true;
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			collector.addLight(this);
		}
		
		public function drawShadowMap(context3d:GpuContext, render3d:RenderSystem):void
		{
			shadowMap.setRenderToSelfAndClear(context3d);
			context3d.setVc(0, constVc, 4);
			context3d.setColorMask(false, false, false, true);
			render3d.render(context3d, RenderPass.GEOMETRY_PASS);
			context3d.setColorMask(true, true, true, true);
		}
		
		public function drawLight(context3d:GpuContext, cameraTransform:Matrix3D):void
		{
			matrix.copyFrom(cameraTransform);
			matrix.append(viewMatrix.transform);
			matrix.copyRawDataTo(constFc, 16, true);
			
			constFc[4]  =  context3d.backBufferWidth;
			constFc[5]  = -context3d.backBufferHeight;
			constFc[15] =  environmentBrightness;
			
			context3d.setTextureAt(1, shadowMap);
			context3d.setFc(0, constFc, 7);
			ScreenDrawer.Draw(context3d);
		}
		
		static private const matrix:Matrix3D = new Matrix3D();
	}
}