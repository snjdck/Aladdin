package snjdck.g2d.obj2d
{
	import flash.display3D.Context3DClearMask;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DStencilAction;
	import flash.display3D.Context3DTriangleFace;
	
	import snjdck.g2d.impl.DisplayObjectContainer2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.asset.GpuContext;
	
	public class StencilMaskSprite extends DisplayObjectContainer2D
	{
		static private const MAX_RECURSIVE_COUNT:int = 8;
		static private var stencilIndex:int = 0;
		
		private var maskImage:Image;
		
		public function StencilMaskSprite(maskImage:Image)
		{
			this.maskImage = maskImage;
		}
		
		override public function draw(render:Render2D, context3d:GpuContext):void
		{
			if(stencilIndex >= MAX_RECURSIVE_COUNT){
				throw new Error("stencil mask is too much!");
			}
			
			drawMask(render, context3d, 0xFF, (2 << stencilIndex) - 1);
			++stencilIndex;
			super.draw(render, context3d);
			--stencilIndex;
			if(stencilIndex > 0){
				drawMask(render, context3d, 0x00, (1 << stencilIndex) - 1);
			}else{//重置回默认状态
				context3d.clearStencil();
				context3d.setStencilActions();
			}
		}
		
		private function drawMask(render:Render2D, context3d:GpuContext, refValue:uint, readMask:uint):void
		{
			context3d.setStencilReferenceValue(refValue, 0xFF, 1 << stencilIndex);
			context3d.setStencilActions(
				Context3DTriangleFace.FRONT_AND_BACK,
				Context3DCompareMode.NEVER,
				Context3DStencilAction.KEEP,
				Context3DStencilAction.KEEP,
				Context3DStencilAction.SET
			);
			maskImage.draw(render, context3d);
			context3d.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.EQUAL);
			context3d.setStencilReferenceValue(0xFF, readMask);
		}
	}
}