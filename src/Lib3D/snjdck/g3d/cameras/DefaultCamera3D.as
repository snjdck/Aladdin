package snjdck.g3d.cameras
{
	import flash.geom.Matrix3D;
	
	import snjdck.g3d.bounds.IBound;
	import snjdck.g3d.lights.ILight3D;
	import snjdck.g3d.render.IDrawUnit3D;
	import snjdck.g3d.rendersystem.RenderSystem;
	import snjdck.g3d.rendersystem.subsystems.RenderPass;
	import snjdck.g3d.rendersystem.subsystems.RenderSystemFactory;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.support.GpuConstData;
	
	public class DefaultCamera3D implements ICamera3D
	{
		static private const cameraMatrix:Matrix3D = new Matrix3D();
		
		static public var zNear	:Number = -2000;
		static public var zRange:Number =  4000;
		
		private const constData:Vector.<Number> = new Vector.<Number>(20, true);
		private var system:RenderSystem;
		
		public function DefaultCamera3D()
		{
			system = RenderSystemFactory.CreateRenderSystem();
			
			constData[2] = zRange;
			constData[3] = zNear;
			
			GpuConstData.SetMatrix(constData, 1, cameraMatrix);
		}
		
		public function setScreenSize(width:int, height:int):void
		{
			constData[0] = 0.5 * width;
			constData[1] = 0.5 * height;
		}
		
		public function draw(context3d:GpuContext):void
		{
			context3d.setVc(0, constData);
			system.render(context3d, RenderPass.MATERIAL_PASS);
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
	}
}