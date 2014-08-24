package snjdck.g2d.obj2d
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Object3D;
	import snjdck.gpu.GpuRender;
	import snjdck.gpu.ViewPort3D;
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
		private var target:Object3D;
		private var scissorRect:Rectangle;
		
		public function Image3D(obj3d:Object3D, w:int, h:int)
		{
			this.target = obj3d;
			this.width = w;
			this.height = h;
			scissorRect = new Rectangle(0, 0, w, h);
		}
		
		override public function onUpdate(timeElapsed:int, parentWorldMatrix:Matrix, parentWorldAlpha:Number):void
		{
			super.onUpdate(timeElapsed, parentWorldMatrix, parentWorldAlpha);
			target.ns_g3d::onUpdate(timeElapsed, ViewPort3D.isoMatrix);
		}
		
		override public function draw(render:GpuRender, context3d:GpuContext):void
		{
			render.r2d.drawEnd(context3d);
			
			scissorRect.x = x;
			scissorRect.y = y;
			
			context3d.clearDepthAndStencil();
			context3d.setScissorRect(scissorRect);
			render.r3d.offset(
				x - 0.5 * (render.screenWidth - width),
				0.5 * (render.screenHeight - height) - y
			);
			render.drawScene3D(target, context3d);
			render.r3d.offset();
			context3d.setScissorRect(null);
			
			render.r2d.uploadProjectionMatrix(context3d);
			render.r2d.drawBegin(context3d);
		}
		
	}
}