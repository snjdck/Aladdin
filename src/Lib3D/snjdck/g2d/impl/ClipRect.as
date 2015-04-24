package snjdck.g2d.impl
{
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DStencilAction;
	import flash.display3D.Context3DTriangleFace;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.asset.GpuContext;

	internal class ClipRect extends Rectangle
	{
		static private const MAX_RECURSIVE_COUNT:int = 8;
		static private var stencilIndex:int = 0;
		
		private var worldMatrix:Matrix;
		
		public function ClipRect(worldMatrix:Matrix)
		{
			this.worldMatrix = worldMatrix;
		}
		
		public function drawBegin(render2d:Render2D, context3d:GpuContext):void
		{
			if(stencilIndex >= MAX_RECURSIVE_COUNT){
				throw new Error("stencil mask is too much!");
			}
			drawMask(render2d, context3d, 0xFF, (2 << stencilIndex) - 1);
			++stencilIndex;
		}
		
		public function drawEnd(render2d:Render2D, context3d:GpuContext):void
		{
			--stencilIndex;
			if(stencilIndex > 0){
				drawMask(render2d, context3d, 0x00, (1 << stencilIndex) - 1);
			}else{//重置回默认状态
				context3d.clearStencil();
				context3d.setStencilActions();
			}
		}
		
		private function drawMask(render2d:Render2D, context3d:GpuContext, refValue:uint, readMask:uint):void
		{
			context3d.setStencilReferenceValue(refValue, 0xFF, 1 << stencilIndex);
			context3d.setStencilActions(
				Context3DTriangleFace.FRONT_AND_BACK,
				Context3DCompareMode.NEVER,
				Context3DStencilAction.KEEP,
				Context3DStencilAction.KEEP,
				Context3DStencilAction.SET
			);
			render2d.drawLocalRect(context3d, worldMatrix, x, y, width, height);
			
			context3d.setStencilActions(
				Context3DTriangleFace.FRONT_AND_BACK,
				Context3DCompareMode.EQUAL
			);
			context3d.setStencilReferenceValue(0xFF, readMask);
		}
	}
}