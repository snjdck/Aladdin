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
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.render.ScreenDrawer;
	import snjdck.gpu.support.CubeRotationMatrix;
	import snjdck.gpu.support.GpuConstData;
	
	import vec3.subtract;
	
	public class PointLight3D extends Object3D implements ILight3D
	{
		static public const SHADOW_BIAS:Number = 0.0022;
		static public const SHADOW_MAP_SIZE:int = 1024;
		public var environmentBrightness:Number = 0.4;
		
		private var shadowMap:GpuRenderTarget;
		private const constVc:Vector.<Number> = new Vector.<Number>(20);
		private const constFc:Vector.<Number> = new Vector.<Number>(32);
		
		public function PointLight3D()
		{
			GpuConstData.SetNumber(constVc, 0, 1, 1, Camera3D.zRange, 0);
			
			GpuConstData.SetNumber(constFc, 0, 0.5, 0.5, -Camera3D.zNear / Camera3D.zRange, SHADOW_BIAS);
			GpuConstData.SetNumber(constFc, 1, 0, 0, Camera3D.zRange, 1);
			
			shadowMap = new GpuRenderTarget(SHADOW_MAP_SIZE, SHADOW_MAP_SIZE, Context3DTextureFormat.BGRA, true);
			shadowMap.backgroundColor = 0xFF000000;
			shadowMap.enableDepthAndStencil = true;
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			collector.addLight(this);
		}
		
		public function drawShadowMap(context3d:GpuContext, render3d:RenderSystem, cameraPosition:Vector3D):void
		{
			extractPosition(worldTransform, offset);
			for(var i:int=0; i<6; ++i){
				GpuConstData.SetMatrix(constVc, 1, matrixList.getMatrixAt(i));
				GpuConstData.SetVector(constVc, 4, offset);
				context3d.setVc(0, constVc);
				shadowMap.setRenderToSelfAndClear(context3d, i);
				render3d.render(context3d, RenderPass.DEPTH_CUBE_PASS);
			}
		}
		
		public function drawLight(context3d:GpuContext, cameraRotation:Matrix3D, cameraPosition:Vector3D):void
		{
			extractPosition(worldTransform, offset);
			vec3.subtract(cameraPosition, offset, offset);
			GpuConstData.SetMatrix(constFc, 4, cameraRotation);
			
			constFc[4]  =  context3d.backBufferWidth;
			constFc[5]  = -context3d.backBufferHeight;
			constFc[15] =  environmentBrightness;
			GpuConstData.SetVector(constFc, 2, offset);
			GpuConstData.SetMatrix(constFc, 4, cameraRotation);
			
			context3d.setFc(0, constFc, 7);
			context3d.program = AssetMgr.Instance.getProgram("point_light_pass");
			context3d.setTextureAt(1, shadowMap);
			ScreenDrawer.Draw(context3d);
		}
		
		static private const matrixList:CubeRotationMatrix = new CubeRotationMatrix();
		static private const offset:Vector3D = new Vector3D();
	}
}