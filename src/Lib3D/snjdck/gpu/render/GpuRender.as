package snjdck.gpu.render
{
	import flash.utils.getTimer;
	
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g3d.core.Object3D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.g2d.render.Render2D;
	import snjdck.g3d.render.Render3D;

	public class GpuRender implements IRender
	{
		public const r3d:Render3D = new Render3D();
		public const r2d:Render2D = new Render2D();
		
		public function GpuRender(){}
		
		public function pushScreen(width:int, height:int, offsetX:Number=0, offsetY:Number=0):void
		{
			r3d.pushScreen(width, height, offsetX, offsetY);
			r2d.pushScreen(width, height, offsetX, offsetY);
		}
		
		public function popScreen():void
		{
			r3d.popScreen();
			r2d.popScreen();
		}
		
		public function drawScene3D(scene3d:Object3D, context3d:GpuContext):void
		{
			r3d.draw(scene3d, context3d);
		}
		
		public function drawScene2D(scene2d:IDisplayObject2D, context3d:GpuContext):void
		{
//			r2d.uploadProjectionMatrix(context3d);
			r2d.drawBegin(context3d);
			var t:int = getTimer();
			scene2d.draw(this, context3d);
			trace("scene2d render",getTimer()-t);
		}
	}
}