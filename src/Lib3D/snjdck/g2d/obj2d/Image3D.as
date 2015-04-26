package snjdck.g2d.obj2d
{
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.g3d.Scene3D;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.support.Camera3DFactory;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g2d;
	
	public class Image3D extends DisplayObject2D
	{
		private var camera3d:Camera3D;
		public const scene3d:Scene3D = new Scene3D();
		
		public function Image3D(w:int, h:int)
		{
			camera3d = Camera3DFactory.NewIsoCamera(1000, 600, -1000, 5000);
			camera3d.localMatrix.identity();
			scene3d.camera = camera3d;
			this.width = w;
			this.height = h;
		}
		
		public function addChild(child:Object3D):void
		{
			scene3d.addChild(child);
		}
		
		override public function onUpdate(timeElapsed:int):void
		{
			super.onUpdate(timeElapsed);
			scene3d.update(timeElapsed);
		}
		
		override protected function onDraw(render2d:Render2D, context3d:GpuContext):void
		{
			context3d.clearDepth();
			camera3d.projection.setViewport(prevWorldMatrix, width, height);
			scene3d.draw(context3d);
			render2d.drawBegin(context3d);
		}
	}
}