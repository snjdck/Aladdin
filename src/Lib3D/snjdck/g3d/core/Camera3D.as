package snjdck.g3d.core
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTextureFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.geom.Quaternion;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.rendersystem.subsystems.RenderPass;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.AssetMgr;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.render.ScreenDrawer;
	
	import stdlib.constant.Unit;
	
	use namespace ns_g3d;
	
	final public class Camera3D extends DrawUnitCollector3D
	{
		static public var zNear	:Number = -2000;
		static public var zFar	:Number =  2000;
		
		private const viewFrusum:ViewFrustum = new ViewFrustum();
		
		private const rotation:Quaternion = new Quaternion();
		
		public var bindTarget:Object3D;
		
		private const constData:Vector.<Number> = new Vector.<Number>(12, true);
		
		public function Camera3D()
		{
			constData[2] = zFar - zNear;
			constData[3] = zNear;
			rotation.fromEulerAngles(120 * Unit.RADIAN, 0, -45 * Unit.RADIAN);
			constData[4] = rotation.x;
			constData[5] = rotation.y;
			constData[6] = rotation.z;
			constData[7] = -rotation.w;
		}
		
		public function setScreenSize(width:int, height:int):void
		{
			viewFrusum.resize(width, height);
			constData[0] = 0.5 * width;
			constData[1] = 0.5 * height;
			if(geometryTexture != null){
				geometryTexture.dispose();
			}
			geometryTexture = new GpuRenderTarget(width, height, Context3DTextureFormat.RGBA_HALF_FLOAT);
			geometryTexture.enableDepthAndStencil = true;
			
			if(shadowTexture != null){
				shadowTexture.dispose();
			}
			shadowTexture = new GpuRenderTarget(2048, 2048, Context3DTextureFormat.BGRA);
			shadowTexture.enableDepthAndStencil = true;
			
		}
		
		public function update(timeElapsed:int):void
		{
			if(bindTarget != null){
				bindTarget.worldTransform.copyColumnTo(3, viewFrusum.center);
				constData[8] = viewFrusum.center.x;
				constData[9] = viewFrusum.center.y;
				constData[10] = viewFrusum.center.z;
			}else{
				constData[8] = constData[9] = constData[10] = 0;
			}
		}
		
		override public function draw(context3d:GpuContext):void
		{
			context3d.setVc(0, constData);
			system.render(context3d, RenderPass.MATERIAL_PASS);
			
			geometryTexture.setRenderToSelfAndClear(context3d);
			system.render(context3d, RenderPass.GEOMETRY_PASS);
			//draw shadow map
			//*
			lightConstData[0] = lightConstData[1] = 1024;
			lightConstData[2] = zFar - zNear;
			lightConstData[3] = zNear;
			tempRot.fromEulerAngles(135 * Unit.RADIAN, 0, -90 * Unit.RADIAN);
			tempRot.w *= -1;
			lightConstData[4] = tempRot.x;
			lightConstData[5] = tempRot.y;
			lightConstData[6] = tempRot.z;
			lightConstData[7] = tempRot.w;
			context3d.setVc(0, lightConstData, 2);
			
			shadowTexture.setRenderToSelfAndClear(context3d);
			context3d.setColorMask(false, false, false, true);
			system.render(context3d, RenderPass.GEOMETRY_PASS);
			context3d.setColorMask(true, true, true, true);
			context3d.renderTarget = null;
			
			tempRot.prepend(rotation, mat);
			mat.toMatrix(matrix, v);
			
			context3d.setTextureAt(0, geometryTexture);
			context3d.setTextureAt(1, shadowTexture);
			context3d.program = AssetMgr.Instance.getProgram("light_pass");
			context3d.blendMode = BlendMode.MULTIPLY;
			context3d.setDepthTest(false, Context3DCompareMode.LESS);
			context3d.setFc(0, new <Number>[
				0.5, 0.5, zNear/(zNear-zFar), 0.0022,
				context3d.backBufferWidth, -context3d.backBufferHeight, zFar-zNear, 0,
				2048, -2048, zFar-zNear, 1,
				Math.SQRT1_2, 0, Math.SQRT1_2, 0.4
			], 4);
			context3d.setFcM(4, matrix);
			ScreenDrawer.Draw(context3d);
		}
		static private var mat:Quaternion = new Quaternion();
		static private var matrix:Matrix3D = new Matrix3D();
		static private var v:Vector3D = new Vector3D();
		
		override public function isInSight(bound:AABB):Boolean
		{
			return viewFrusum.classify(bound) <= 0;
		}
		/**
		 * @param screenX [-w/2, w/2]
		 * @param screenY [-h/2, h/2]
		 */		
		public function getSceneRay(stageX:Number, stageY:Number, ray:Ray):void
		{
			ray.pos.setTo(stageX, stageY, zNear);
			ray.dir.setTo(0, 0, 1);
//			ray.transform(_worldMatrix, ray);
			rotation.rotateVector(ray.dir, ray.dir);
			rotation.rotateVector(ray.pos, ray.pos);
			ray.pos.incrementBy(viewFrusum.center);
		}
		/*
		public function world2camera(input:Vector3D, output:Vector3D):void
		{
			matrix44.transformVector(_worldMatrixInvert, input, output);
		}
		//*/
		public function getViewFrustum():ViewFrustum
		{
			return viewFrusum;
		}
		/*
		public function getCameraZ(result:Vector3D):void
		{
			_worldMatrix.copyColumnTo(2, result);
		}
		*/
		private var geometryTexture:GpuRenderTarget;
		private var shadowTexture:GpuRenderTarget;
		private var lightConstData:Vector.<Number> = new Vector.<Number>(8);
		static private const tempRot:Quaternion = new Quaternion();
	}
}