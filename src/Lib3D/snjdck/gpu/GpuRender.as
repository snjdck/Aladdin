package snjdck.gpu
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
		
		private var _screentWidth:int;
		private var _screentHeight:int;
		
		public function GpuRender()
		{
		}
		
		public function get screenWidth():int
		{
			return _screentWidth;
		}
		
		public function get screenHeight():int
		{
			return _screentHeight;
		}
		
		public function resize(width:int, height:int):void
		{
			_screentWidth = width;
			_screentHeight = height;
			r3d.setScreenSize(width, height);
			r2d.setScreenSize(width, height);
		}
		
		public function drawScene3D(scene3d:Object3D, context3d:GpuContext):void
		{
			r3d.uploadProjectionMatrix(context3d);
			r3d.draw(scene3d, context3d);
		}
		
		public function drawScene2D(scene2d:IDisplayObject2D, context3d:GpuContext):void
		{
			r2d.uploadProjectionMatrix(context3d);
			r2d.drawBegin(context3d);
			scene2d.draw(this, context3d);
			r2d.drawEnd(context3d);
		}
	}
}