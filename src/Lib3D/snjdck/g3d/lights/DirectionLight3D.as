package snjdck.g3d.lights
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.cameras.Camera3D;
	import snjdck.g3d.cameras.ProjectionData;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.renderer.IDrawUnitCollector3D;
	import snjdck.g3d.rendersystem.RenderSystem;
	import snjdck.g3d.rendersystem.subsystems.RenderTag;
	import snjdck.g3d.rendersystem.subsystems.RenderType;
	import snjdck.g3d.utils.RotationMatrix;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.render.ScreenDrawer;
	import snjdck.gpu.support.GpuConstData;
	
	use namespace ns_g3d;
	
	public class DirectionLight3D extends Object3D implements ILight3D
	{
		static public const SHADOW_BIAS:Number = 0.0022;
		static public const SHADOW_MAP_SIZE:int = 2048;
		
		public var environmentBrightness:Number = 0.4;
		
		private var shadowMap:GpuRenderTarget;
		private const constFc:Vector.<Number> = new Vector.<Number>(32);
		private const direction:Vector3D = new Vector3D(-Math.SQRT1_2, 0, -Math.SQRT1_2);
		private const projectionData:ProjectionData = new ProjectionData(true);
		private var viewMatrix:RotationMatrix;
		
		public function DirectionLight3D()
		{
			viewMatrix = new RotationMatrix(Vector3D.Z_AXIS, direction);
			
			projectionData.zNear = Camera3D.zNear;
			projectionData.zRange = Camera3D.zRange;
			projectionData.setViewPort(SHADOW_MAP_SIZE, SHADOW_MAP_SIZE);
			
			GpuConstData.SetNumber(constFc, 0, 0.5, 0.5, -Camera3D.zNear / Camera3D.zRange, SHADOW_BIAS);
			GpuConstData.SetNumber(constFc, 1, 0, 1, Camera3D.zRange, 1);
			GpuConstData.SetNumber(constFc, 2, SHADOW_MAP_SIZE, -SHADOW_MAP_SIZE, Camera3D.zRange, 0);
			GpuConstData.SetNumber(constFc, 3, -direction.x, -direction.y, -direction.z, 0);
			
			shadowMap = new GpuRenderTarget(SHADOW_MAP_SIZE, SHADOW_MAP_SIZE);
			shadowMap.backgroundColor = 0xFF000000;
			shadowMap.enableDepthAndStencil = true;
		}
		
		override ns_g3d function collectDrawUnit(collector:IDrawUnitCollector3D):void
		{
			collector.addLight(this);
		}
		
		public function drawShadowMap(context3d:GpuContext, render3d:RenderSystem, cameraPosition:Vector3D):void
		{
			matrix.copyFrom(viewMatrix.transform);
			matrix.prependTranslation(-cameraPosition.x, -cameraPosition.y, -cameraPosition.z);
			context3d.setVcM(2, matrix);
			projectionData.upload(context3d);
			shadowMap.setRenderToSelfAndClear(context3d);
			render3d.render(context3d, RenderType.DEPTH, ~RenderTag.TERRAIN);
		}
		
		public function drawLight(context3d:GpuContext, cameraRotation:Matrix3D, cameraPosition:Vector3D):void
		{
			matrix.copyFrom(cameraRotation);
			matrix.append(viewMatrix.transform);
			GpuConstData.SetMatrix(constFc, 4, matrix);
			
			constFc[4]  =  constFc[5] * context3d.backBufferWidth / context3d.backBufferHeight;
//			constFc[5]  = -context3d.backBufferHeight;
			constFc[15] =  environmentBrightness;
			
			context3d.setFc(0, constFc, 7);
			context3d.program = AssetMgr.Instance.getProgram("direction_light_pass");
			context3d.setTextureAt(1, shadowMap);
			ScreenDrawer.Draw(context3d);
		}
		
		static private const matrix:Matrix3D = new Matrix3D();
	}
}