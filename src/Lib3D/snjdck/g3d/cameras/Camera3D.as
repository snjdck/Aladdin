package snjdck.g3d.cameras
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTextureFormat;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bounds.IBound;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.lights.ILight3D;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.renderer.IDrawUnit3D;
	import snjdck.g3d.rendersystem.RenderSystem;
	import snjdck.g3d.rendersystem.subsystems.RenderSystemFactory;
	import snjdck.g3d.rendersystem.subsystems.RenderTag;
	import snjdck.g3d.rendersystem.subsystems.RenderType;
	import snjdck.g3d.utils.RotationMatrix;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	
	import stdlib.constant.Unit;
	
	use namespace ns_g3d;
	
	public class Camera3D extends Object3D implements ICamera3D
	{
		static public var zNear	:Number = -1000;
		static public var zRange:Number =  4000;
		static public var zOffset:Number = -1500;
		static public var fov:Number = Math.tan(40 * Unit.RADIAN * 0.5);
		
		private const viewFrusum:ViewFrustum = new ViewFrustum();
		
		private var viewMatrix:RotationMatrix;
		
		private const drawUnitList:Vector.<IDrawUnit3D> = new Vector.<IDrawUnit3D>();
		
		private const system:RenderSystem = RenderSystemFactory.CreateRenderSystem();
		private var lightList:Vector.<ILight3D> = new Vector.<ILight3D>();
		
		private var _width:int;
		private var _height:int;
		
		private const projectionData:ProjectionData = new ProjectionData();
		
		private const cameraPosition:Vector3D = new Vector3D();
		
		public function Camera3D()
		{
			var direction:Vector3D = new Vector3D(-1, -1, -Math.SQRT2);
			direction.normalize();
			viewMatrix = new RotationMatrix(Vector3D.Z_AXIS, direction);
			projectionData.zNear = zNear;
			projectionData.zRange = zRange;
			projectionData.zOffset = zOffset;
			transform = viewMatrix.transformInvert;
		}
		
		public function setScreenSize(width:int, height:int):void
		{
			if(_width == width && _height == height){
				return;
			}
			_width = width;
			_height = height;
			projectionData.setViewPort(width, height, fov);
			projectionData.calcViewFrustum(viewFrusum);
			viewFrusum.updateTransform(viewMatrix.transformInvert);
			if(geometryTexture != null){
				geometryTexture.dispose();
				geometryTexture = null;
			}
		}
		
		override public function onUpdate(timeElapsed:int):void
		{
			worldTransform.copyColumnTo(3, cameraPosition);
			viewFrusum.updatePosition(cameraPosition);
		}
		
		public function draw(context3d:GpuContext):void
		{
			projectionData.upload(context3d);
			context3d.setVcM(2, worldTransformInvert);
			system.render(context3d, RenderType.MATERIAL, ~(RenderTag.HERO | RenderTag.TERRAIN));
			system.render(context3d, RenderType.HERO_PASS, RenderTag.HERO);
			system.render(context3d, RenderType.MATERIAL, RenderTag.HERO | RenderTag.TERRAIN);
			
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
			system.render(context3d, RenderType.GEOMETRY);
			
			context3d.setColorMask(false, false, false, true);
			for(lightIndex=0; lightIndex<lightCount; ++lightIndex){
				light = getLightAt(lightIndex);
				light.drawShadowMap(context3d, system, cameraPosition);
			}
			context3d.setColorMask(true, true, true, true);
			
			context3d.renderTarget = null;
			context3d.setTextureAt(0, geometryTexture);
			context3d.blendMode = BlendMode.MULTIPLY;
			context3d.setDepthTest(false, Context3DCompareMode.LESS);
			
			for(lightIndex=0; lightIndex<lightCount; ++lightIndex){
				light = getLightAt(lightIndex);
				light.drawLight(context3d, viewMatrix.transformInvert, cameraPosition);
			}
		}
		
		public function isInSight(bound:IBound):Boolean
		{
			return true;
			return viewFrusum.classify(bound) <= 0;
		}
		/**
		 * @param screenX [-w/2, w/2]
		 * @param screenY [-h/2, h/2]
		 */		
		public function getSceneRay(stageX:Number, stageY:Number, ray:Ray):void
		{
			projectionData.calcCameraSpaceRay(stageX, stageY, ray.pos, ray.dir);
			ray.transform(worldTransform, ray);
		}
		
		public function getViewFrustum():IViewFrustum
		{
			return viewFrusum;
		}
		
		private var geometryTexture:GpuRenderTarget;
		
		public function clear():void
		{
			system.clear();
			drawUnitList.length = 0;
			lightList.length = 0;
		}
		
		public function getLightCount():int
		{
			return lightList.length;
		}
		
		public function getLightAt(index:int):ILight3D
		{
			return lightList[index];
		}
		
		public function addDrawUnit(drawUnit:IDrawUnit3D, priority:int):void
		{
			drawUnit.tag = _tag;
			system.addItem(drawUnit, priority);
			drawUnitList.push(drawUnit);
		}
		
		public function addLight(light:ILight3D):void
		{
			lightList.push(light);
		}
		
		public function pickup(worldRay:Ray, result:Vector.<Object3D>):void
		{
			if(drawUnitList.length <= 0)
				return;
			for each(var drawUnit:IDrawUnit3D in drawUnitList)
			drawUnit.hitTest(worldRay, result);
		}
		
		private var _prevTag:uint;
		private var _tag:uint;
		
		public function markTag(value:uint):void
		{
			_prevTag = _tag;
			_tag = value;
		}
		
		public function unmarkTag(value:uint):void
		{
			_tag = _prevTag;
		}
		
		public function get depth():int
		{
			return 0;
		}
	}
}