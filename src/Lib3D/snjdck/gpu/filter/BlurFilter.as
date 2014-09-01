package snjdck.gpu.filter
{
	import flash.display3D.Context3DBlendFactor;
	
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.GpuRender;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.asset.helper.AssetMgr;

	public class BlurFilter extends FragmentFilter
	{
		static public function createGlowFilter(blurX:Number, blurY:Number, color:uint, alpha:Number):FragmentFilter
		{
			var filter:BlurFilter = new BlurFilter();
			filter.mode = FragmentFilterMode.BELOW;
			filter.glowColor = new <Number>[1,1,0,1];
			return filter;
		}
		
		static private const blendMode:BlendMode = new BlendMode(
			Context3DBlendFactor.ONE,
			Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA
		);
		
		public var blurX:Number = 4;
		public var blurY:Number = 4;
		
		private var frontBuffer:GpuRenderTarget;
		private var backBuffer:GpuRenderTarget;
		private var numPasses:int;
		private var glowColor:Vector.<Number> = new Vector.<Number>(4, true);
		
		public function BlurFilter()
		{
		}
		
		override protected function onDrawBegin(target:IDisplayObject2D):void
		{
			numPasses = Math.ceil(blurX) + Math.ceil(blurY);
			
			target.getBounds(null, bounds);
			bounds.inflate(Math.ceil(blurX)+4, Math.ceil(blurY)+4);
			
			frontBuffer = new GpuRenderTarget(bounds.width, bounds.height);
			image = frontBuffer;
			
			if(numPasses < 2){
				return;
			}
			
			backBuffer = new GpuRenderTarget(bounds.width, bounds.height);
			
			if(mode == FragmentFilterMode.BELOW && numPasses > 2){
				image = new GpuRenderTarget(bounds.width, bounds.height);
			}
		}
		
		override protected function onDrawEnd():void
		{
			if(frontBuffer != null){
				frontBuffer.dispose();
				frontBuffer = null;
			}
			
			backBuffer.dispose();
			backBuffer = null;
			
			image.dispose();
			image = null;
		}
		
		override protected function drawFilter(prevRenderTarget:GpuRenderTarget, render:GpuRender, context3d:GpuContext):void
		{
			render.r2d.pushScreen();
			render.r2d.setScreenSize(bounds.width, bounds.height);
			render.r2d.uploadProjectionMatrix(context3d);
			render.r2d.popScreen();
			
			context3d.setProgram(AssetMgr.Instance.getProgram("blur"));
			context3d.setBlendFactor(BlendMode.NORMAL);
			
			vertexData.reset(0, 0, bounds.width, bounds.height);
			
			for(var i:int=0; i<numPasses; i++)
			{
				updateParameters(i);
				
				context3d.setVc(4, mOffsets, 1);
				context3d.setFc(0, mWeights, 1);
				
				swapBuffer();
				
				const isLastPass:Boolean = (i + 1 == numPasses);
				
				if(isLastPass){
					context3d.renderTarget = prevRenderTarget;
					drawLastPass(render, context3d);
				}else{
					context3d.renderTarget = frontBuffer;
					frontBuffer.clear(context3d);
				}
				
				var texture:IGpuTexture = (0 == i ? image : backBuffer);
				render.r2d.drawTexture(context3d, vertexData, texture);
				render.r2d.drawEnd(context3d);
			}
		}
		
		private function drawLastPass(render:GpuRender, context3d:GpuContext):void
		{
			context3d.setProgram(AssetMgr.Instance.getProgram("blur_tint"));
			context3d.setBlendFactor(blendMode);
			context3d.setFc(1, glowColor, 1);
			vertexData.reset(bounds.x, bounds.y, bounds.width, bounds.height);
			render.r2d.uploadProjectionMatrix(context3d);
		}
		
		private function swapBuffer():void
		{
			var temp:GpuRenderTarget = frontBuffer;
			frontBuffer = backBuffer;
			backBuffer = temp;
		}
		
		static private const MAX_SIGMA:Number = 2.0;
		static private const sTmpWeights:Vector.<Number> = new Vector.<Number>(5, true);
		static private const mOffsets:Vector.<Number> = new Vector.<Number>(4, true);
		static private const mWeights:Vector.<Number> = new Vector.<Number>(4, true);
		
		private function updateParameters(pass:int):void
		{
			// algorithm described here: 
			// http://rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/
			// 
			// To run in constrained mode, we can only make 5 texture lookups in the fragment
			// shader. By making use of linear texture sampling, we can produce similar output
			// to what would be 9 lookups.
			
			const textureWidth:int = bounds.width;
			const textureHeight:int = bounds.height;
			
			var sigma:Number;
			var horizontal:Boolean = pass < blurX;
			var pixelSize:Number;
			
			if (horizontal)
			{
				sigma = Math.min(1.0, blurX - pass) * MAX_SIGMA;
				pixelSize = 1.0 / textureWidth; 
			}
			else
			{
				sigma = Math.min(1.0, blurY - (pass - Math.ceil(blurX))) * MAX_SIGMA;
				pixelSize = 1.0 / textureHeight;
			}
			
			const twoSigmaSq:Number = 2 * sigma * sigma; 
			const multiplier:Number = 1.0 / Math.sqrt(twoSigmaSq * Math.PI);
			
			// get weights on the exact pixels (sTmpWeights) and calculate sums (mWeights)
			
			for (var i:int=0; i<5; ++i)
				sTmpWeights[i] = multiplier * Math.exp(-i*i / twoSigmaSq);
			
			mWeights[0] = sTmpWeights[0];
			mWeights[1] = sTmpWeights[1] + sTmpWeights[2]; 
			mWeights[2] = sTmpWeights[3] + sTmpWeights[4];
			
			// normalize weights so that sum equals "1.0"
			
			var weightSum:Number = mWeights[0] + 2*mWeights[1] + 2*mWeights[2];
			var invWeightSum:Number = 1.0 / weightSum;
			
			mWeights[0] *= invWeightSum;
			mWeights[1] *= invWeightSum;
			mWeights[2] *= invWeightSum;
			
			// calculate intermediate offsets
			
			var offset1:Number = (  pixelSize * sTmpWeights[1] + 2*pixelSize * sTmpWeights[2]) / mWeights[1];
			var offset2:Number = (3*pixelSize * sTmpWeights[3] + 4*pixelSize * sTmpWeights[4]) / mWeights[2];
			
			// depending on pass, we move in x- or y-direction
			
			if (horizontal) 
			{
				mOffsets[0] = offset1;
				mOffsets[1] = 0;
				mOffsets[2] = offset2;
				mOffsets[3] = 0;
			}
			else
			{
				mOffsets[0] = 0;
				mOffsets[1] = offset1;
				mOffsets[2] = 0;
				mOffsets[3] = offset2;
			}
		}
	}
}