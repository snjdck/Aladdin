package snjdck.g2d.obj2d
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.gpu.View3D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.render.GpuRender;
	
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
		private const scissorRect:Rectangle = new Rectangle();
		private var target:Object3D;
		
		public function Image3D(obj3d:Object3D, w:int, h:int)
		{
			this.target = obj3d;
			this.width = w;
			this.height = h;
		}
		
		override public function onUpdate(timeElapsed:int, parentWorldMatrix:Matrix, parentWorldAlpha:Number):void
		{
			super.onUpdate(timeElapsed, parentWorldMatrix, parentWorldAlpha);
			target.ns_g3d::onUpdate(timeElapsed, View3D.isoMatrix);
		}
		
		override public function draw(render:GpuRender, context3d:GpuContext):void
		{
			context3d.clearDepthAndStencil();
			context3d.setScissorRect(scissorRect);
			render.drawScene3D(target, context3d,
				x - 0.5 * (context3d.bufferWidth - width),
				0.5 * (context3d.bufferHeight - height) - y
			);
			context3d.setScissorRect(null);
			
			render.r2d.drawBegin(context3d);
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