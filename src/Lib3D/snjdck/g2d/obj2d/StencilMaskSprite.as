package snjdck.g2d.obj2d
{
	import flash.display3D.Context3DClearMask;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DStencilAction;
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Matrix;
	
	import snjdck.g2d.impl.DisplayObjectContainer2D;
	import snjdck.gpu.GpuRender;
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
		
		override public function onUpdate(timeElapsed:int, parentWorldMatrix:Matrix, parentWorldAlpha:Number):void
		{
			super.onUpdate(timeElapsed, parentWorldMatrix, parentWorldAlpha);
			maskImage.onUpdate(timeElapsed, worldMatrix, worldAlpha);
		}
		
		override public function draw(render:GpuRender, context3d:GpuContext):void
		{
			if(stencilIndex >= MAX_RECURSIVE_COUNT){
				throw new Error("stencil mask is too much!");
			}
			
			drawMask(render, context3d, 0xFF);
			enableClipping(context3d, (2 << stencilIndex) - 1);
			
			++stencilIndex;
			
			super.draw(render, context3d);
			
			--stencilIndex;
			
			if(stencilIndex > 0){
				drawMask(render, context3d, 0x00);
				enableClipping(context3d, (1 << stencilIndex) - 1);
			}else{//重置回默认状态
				context3d.clear(0, 0, 0, 1, 1, 0, Context3DClearMask.STENCIL);
				context3d.setStencilActions();
			}
		}
		
		private function drawMask(render:GpuRender, context3d:GpuContext, refValue:uint):void
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
		}
		
		private function enableClipping(context3d:GpuContext, readMask:uint):void
		{
			context3d.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.EQUAL);
			context3d.setStencilReferenceValue(0xFF, readMask);
		}
	}
}