package snjdck.g2d.obj2d
{
	import flash.geom.Matrix3D;
	
	import snjdck.g3d.bounds.IBound;
	import snjdck.g3d.cameras.ICamera3D;
	import snjdck.g3d.cameras.IViewFrustum;
	import snjdck.g3d.lights.ILight3D;
	import snjdck.g3d.renderer.IDrawUnit3D;
	import snjdck.g3d.rendersystem.RenderSystem;
	import snjdck.g3d.rendersystem.subsystems.RenderSystemFactory;
	import snjdck.g3d.rendersystem.subsystems.RenderType;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.support.GpuConstData;
	
	internal class Image3DCamera implements ICamera3D
	{
		static private const cameraMatrix:Matrix3D = new Matrix3D();
		
		static public var zNear	:Number = -2000;
		static public var zRange:Number =  4000;
		
		private const constData:Vector.<Number> = new Vector.<Number>(24, true);
		private var system:RenderSystem;
		
		public function Image3DCamera()
		{
			system = RenderSystemFactory.CreateRenderSystem();
			
			constData[2] = zRange;
			constData[3] = zNear;
			
			GpuConstData.SetNumber(constData, 1, 0, 1, 0, 0);
			GpuConstData.SetMatrix(constData, 2, cameraMatrix);
		}
		
		public function setScreenSize(width:int, height:int):void
		{
			constData[0] = 0.5 * width;
			constData[1] = 0.5 * height;
		}
		
		public function draw(context3d:GpuContext):void
		{
			context3d.setVc(0, constData, 5);
			system.render(context3d, RenderType.MATERIAL);
		}
		
		public function clear():void
		{
			system.clear();
		}
		
		public function addDrawUnit(drawUnit:IDrawUnit3D, priority:int):void
		{
			system.addItem(drawUnit, priority);
		}
		
		public function addLight(light:ILight3D):void
		{
		}
		
		public function getLightAt(index:int):ILight3D
		{
			return null;
		}
		
		public function getLightCount():int
		{
			return 0;
		}
		
		public function isInSight(bound:IBound):Boolean
		{
			return true;
		}
		
		public function getViewFrustum():IViewFrustum
		{
			return null;
		}
		
		public function markTag(value:uint):void
		{
		}
		
		public function unmarkTag(value:uint):void
		{
		}
		
		public function get depth():int
		{
			return 0;
		}
	}
}