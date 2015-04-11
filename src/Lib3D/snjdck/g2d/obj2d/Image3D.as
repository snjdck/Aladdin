package snjdck.g2d.obj2d
{
	import flash.geom.Rectangle;
	
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.render.Render3D;
	import snjdck.g3d.support.Camera3DFactory;
	import snjdck.gpu.asset.GpuContext;
	
	/**
	 * 
	 * @author shaokai
	 * 
	 * 
	 * mvp matrix
	 * program
	 * const
	 * depth write
	 * blend mode
	 */	
	public class Image3D extends DisplayObject2D
	{
		private var camera3d:Camera3D;
		private const scissorRect:Rectangle = new Rectangle();
//		private var target:Object3D;
		private var scene3d:Object3D = new Object3D();
		private var r3d:Render3D = new Render3D();
		
		public function Image3D(obj3d:Object3D, w:int, h:int)
		{
//			this.target = obj3d;
			camera3d = Camera3DFactory.NewIsoCamera(1280, 720, 0, 5000);
			camera3d.zOffset = -1000;
			this.width = w;
			this.height = h;
			scene3d.addChild(obj3d);
			scene3d.addChild(camera3d);
		}
		
		override public function onUpdate(timeElapsed:int):void
		{
			super.onUpdate(timeElapsed);
			scene3d.onUpdate(timeElapsed);
		}
		
		override public function draw(render:Render2D, context3d:GpuContext):void
		{
			context3d.clearDepthAndStencil();
			context3d.setScissorRect(scissorRect);
			camera3d.projection.offsetX =  (x - 0.5 * (context3d.bufferWidth - width)) / context3d.bufferWidth;
			camera3d.projection.offsetY = -(y - 0.5 * (context3d.bufferHeight - height)) / context3d.bufferHeight;
			r3d.draw(scene3d, context3d);
			context3d.setScissorRect(null);
			
			render.drawBegin(context3d);
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			scissorRect.height = value;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			scissorRect.width = value;
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			scissorRect.x = value;
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			scissorRect.y = value;
		}
	}
}