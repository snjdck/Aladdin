package snjdck.g3d.cameras
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTextureFormat;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bounds.AABB;
	import snjdck.g3d.lights.ILight3D;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.g3d.rendersystem.subsystems.RenderPass;
	import snjdck.g3d.utils.RotationMatrix;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	
	use namespace ns_g3d;
	
	final public class Camera3D extends DrawUnitCollector3D implements ICamera3D
	{
		static public var zNear	:Number = -2000;
		static public var zRange:Number =  4000;
		
		private const viewFrusum:ViewFrustum = new ViewFrustum();
		
		private var viewMatrix:RotationMatrix;
		
//		public var bindTarget:Object3D;
		
		private const constData:Vector.<Number> = new Vector.<Number>(20, true);
		
		private var _width:int;
		private var _height:int;
		
		public function Camera3D()
		{
			var direction:Vector3D = new Vector3D(-Math.sqrt(3), -Math.sqrt(3), -Math.SQRT2);
			direction.normalize();
			viewMatrix = new RotationMatrix(Vector3D.Z_AXIS, direction);
			constData[2] = zRange;
			constData[3] = zNear;
			viewMatrix.transform.copyRawDataTo(constData, 4, true);
		}
		
		public function setScreenSize(width:int, height:int):void
		{
			if(_width == width && _height == height){
				return;
			}
			_width = width;
			_height = height;
			viewFrusum.resize(width, height);
			constData[0] = 0.5 * width;
			constData[1] = 0.5 * height;
			if(geometryTexture != null){
				geometryTexture.dispose();
				geometryTexture = null;
			}
		}
		
		override public function onUpdate(timeElapsed:int):void
		{
			worldTransform.copyColumnTo(3, viewFrusum.center);
			constData[16] = viewFrusum.center.x;
			constData[17] = viewFrusum.center.y;
			constData[18] = viewFrusum.center.z;
		}
		
		/*
		public function update(timeElapsed:int):void
		{
			if(bindTarget != null){
				bindTarget.worldTransform.copyColumnTo(3, viewFrusum.center);
				constData[16] = viewFrusum.center.x;
				constData[17] = viewFrusum.center.y;
				constData[18] = viewFrusum.center.z;
			}else{
				constData[16] = constData[17] = constData[18] = 0;
			}
		}
		*/
		override public function draw(context3d:GpuContext):void
		{
			context3d.setVc(0, constData);
			system.render(context3d, RenderPass.MATERIAL_PASS);
			
			const lightCount:int = getLightCount();
			var lightIndex:int, light:ILight3D;
			
			if(lightCount <= 0){
				return;
			}
			
			if(null == geometryTexture){
				geometryTexture = new GpuRenderTarget(context3d.bufferWidth, context3d.bufferHeight, Context3DTextureFormat.RGBA_HALF_FLOAT);
				geometryTexture.enableDepthAndStencil = true;
			}
			
			geometryTexture.setRenderToSelfAndClear(context3d);
			system.render(context3d, RenderPass.GEOMETRY_PASS);
			
			context3d.setColorMask(false, false, false, true);
			for(lightIndex=0; lightIndex<lightCount; ++lightIndex){
				light = getLightAt(lightIndex);
				light.drawShadowMap(context3d, system, viewFrusum.center);
			}
			context3d.setColorMask(true, true, true, true);
			
			context3d.renderTarget = null;
			context3d.setTextureAt(0, geometryTexture);
			context3d.blendMode = BlendMode.MULTIPLY;
			context3d.setDepthTest(false, Context3DCompareMode.LESS);
			
			for(lightIndex=0; lightIndex<lightCount; ++lightIndex){
				light = getLightAt(lightIndex);
				light.drawLight(context3d, viewMatrix.transformInvert, viewFrusum.center);
			}
		}
		
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
			ray.transform(viewMatrix.transformInvert, ray);
			ray.pos.incrementBy(viewFrusum.center);
		}
		/*
		public function world2camera(input:Vector3D, output:Vector3D):void
		{
			matrix44.transformVector(_worldMatrixInvert, input, output);
		}
		//*/
		public function getViewFrustum():IViewFrustum
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
	}
}