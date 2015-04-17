package snjdck.g2d
{
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.impl.DisplayObjectContainer2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.IScene;
	import snjdck.gpu.asset.GpuContext;
	
	public class Scene2D implements IScene
	{
		public const root:DisplayObjectContainer2D = new DisplayObjectContainer2D();
		
		private const render:Render2D = new Render2D();
		
		public function Scene2D()
		{
		}
		
		public function update(timeElapsed:int):void
		{
			root.onUpdate(timeElapsed);
		}
		
		public function draw(context3d:GpuContext):void
		{
			render.pushScreen(context3d.bufferWidth, context3d.bufferHeight);
			render.drawBegin(context3d);
			root.draw(render, context3d);
			render.popScreen();
		}
		
		public function addChild(child:DisplayObject2D):void
		{
			root.addChild(child);
		}
	}
}