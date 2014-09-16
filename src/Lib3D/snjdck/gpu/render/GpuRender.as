package snjdck.gpu.render
{
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.render.Render3D;
	import snjdck.gpu.asset.GpuContext;

	public class GpuRender
	{
		public const r3d:Render3D = new Render3D();
		public const r2d:Render2D = new Render2D();
		
		public function GpuRender(){}
		
		public function drawScene3D(scene3d:Object3D, context3d:GpuContext, offsetX:Number=0, offsetY:Number=0):void
		{
			r3d.pushScreen(context3d.bufferWidth, context3d.bufferHeight, offsetX, offsetY);
			r3d.draw(scene3d, context3d);
			r3d.popScreen();
		}
		
		public function drawScene2D(scene2d:IDisplayObject2D, context3d:GpuContext):void
		{
			r2d.pushScreen(context3d.bufferWidth, context3d.bufferHeight);
			r2d.drawBegin(context3d);
			scene2d.draw(this, context3d);
			r2d.popScreen();
		}
	}
}