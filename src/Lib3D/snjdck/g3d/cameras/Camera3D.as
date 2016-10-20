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
	import snjdck.g3d.terrain.Terrain;
	import snjdck.g3d.utils.RotationMatrix;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.support.GpuConstData;
	
	use namespace ns_g3d;
	
	public class Camera3D extends Object3D implements ICamera3D
	{
		static public var zNear	:Number = -2000;
		static public var zRange:Number =  4000;
		
		private const viewFrusum:ViewFrustum = new ViewFrustum();
		
		private var viewMatrix:RotationMatrix;
		
		private const drawUnitList:Vector.<IDrawUnit3D> = new Vector.<IDrawUnit3D>();
		
		private const system:RenderSystem = RenderSystemFactory.CreateRenderSystem();
		private var lightList:Vector.<ILight3D> = new Vector.<ILight3D>();
		
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
			GpuConstData.SetMatrix(constData, 1, viewMatrix.transform);
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
		
		public function draw(context3d:GpuContext):void
		{
			context3d.setVc(0, constData);
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
		
		public function isInSight(bound:IBound):Boolean
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