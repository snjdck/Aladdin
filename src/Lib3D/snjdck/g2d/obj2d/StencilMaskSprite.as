package snjdck.g2d.obj2d
{
	import flash.display3D.Context3DClearMask;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DStencilAction;
	import flash.display3D.Context3DTriangleFace;
	
	import snjdck.g2d.impl.DisplayObjectContainer2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.g3d.asset.IGpuContext;
	
	public class StencilMaskSprite extends DisplayObjectContainer2D
	{
		static private const MAX_RECURSIVE_COUNT:int = 8;
		static private var stencilIndex:int = 0;
		
		public function StencilMaskSprite()
		{
			super();
		}
		
		override public function draw(render2d:Render2D, context3d:IGpuContext):void
		{
			if(stencilIndex >= MAX_RECURSIVE_COUNT){
				throw new Error("stencil mask is too much!");
			}
			
			context3d.setStencilReferenceValue(0xFF, 0xFF, 1 << stencilIndex);
			setStencilActions(context3d, Context3DCompareMode.ALWAYS, Context3DStencilAction.SET);
			
			drawMaskTexture();
			
			context3d.setStencilReferenceValue(0xFF, (2 << stencilIndex) - 1);
			setStencilActions(context3d, Context3DCompareMode.EQUAL, Context3DStencilAction.KEEP);
			
			++stencilIndex;
			
			super.draw(render2d, context3d);
			
			--stencilIndex;
			
			if(stencilIndex > 0){
				context3d.setStencilReferenceValue(0x00, 0xFF, 1 << stencilIndex);
				setStencilActions(context3d, Context3DCompareMode.NEVER, Context3DStencilAction.KEEP, Context3DStencilAction.SET);
				render2d.drawScreen(context3d);
				setStencilActions(context3d, Context3DCompareMode.EQUAL, Context3DStencilAction.KEEP);
				context3d.setStencilReferenceValue(0xFF, (1 << stencilIndex) - 1);
			}else{//重置回默认状态
				context3d.clear(0, 0, 0, 1, 1, 0, Context3DClearMask.STENCIL);
				context3d.setStencilActions();
			}
		}
		
		private function drawMaskTexture():void
		{
			
		}
		
		[Inline]
		private function setStencilActions(context3d:IGpuContext, compareMode:String, actionOnBothPass:String, actionOnDepthPassStencilFail:String=Context3DStencilAction.KEEP):void
		{
			context3d.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK, compareMode, actionOnBothPass, Context3DStencilAction.KEEP, actionOnDepthPassStencilFail);
		}
	}
}