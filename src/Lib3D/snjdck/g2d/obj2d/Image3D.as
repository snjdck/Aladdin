package snjdck.g2d.obj2d
{
	import flash.geom.Rectangle;
	
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.g3d.Scene3D;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.Object3D;
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
		private var scene3d:Scene3D = new Scene3D();
		
		public function Image3D(obj3d:Object3D, w:int, h:int)
		{
			camera3d = Camera3DFactory.NewIsoCamera(1000, 600, 0, 5000);
			camera3d.zOffset = -1000;
			this.width = w;
			this.height = h;
			scene3d.addChild(obj3d);
			scene3d.camera = camera3d;
		}
		
		override public function onUpdate(timeElapsed:int):void
		{
			super.onUpdate(timeElapsed);
			scene3d.update(timeElapsed);
		}
		
		override protected function onDraw(render2d:Render2D, context3d:GpuContext):void
		{
			if(!context3d.isRectInBuffer(scissorRect)){
				return;
			}
			
			context3d.clearDepth();
			context3d.setScissorRect(scissorRect);
			camera3d.projection.offsetX = (2 * x + width) / context3d.bufferWidth - 1;
			camera3d.projection.offsetY = 1 - (2 * y + height) / context3d.bufferHeight;
			camera3d.uploadMVP(context3d);
			scene3d.draw(context3d);
			context3d.setScissorRect(null);
			
			render2d.drawBegin(context3d);
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