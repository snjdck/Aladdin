package snjdck.g2d.filter
{
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.asset.helper.AssetMgr;
	import snjdck.gpu.asset.helper.ShaderName;

	final public class BlurFilter extends Filter2D
	{
		public var blurX:Number;
		public var blurY:Number;
		
		private var frontBuffer:GpuRenderTarget;
		private var backBuffer:GpuRenderTarget;
		private var numPasses:int;
		
		public function BlurFilter(blurX:Number=1, blurY:Number=1)
		{
			this.blurX = blurX;
			this.blurY = blurY;
		}
		
		override public function draw(target:DisplayObject2D, render:Render2D, context3d:GpuContext):void
		{
			numPasses = Math.ceil(blurX) + Math.ceil(blurY);
			if(numPasses > 0){
				super.draw(target, render, context3d);
			}else{
				target.draw(render, context3d);
			}
		}
		
		override public function renderFilter(texture:IGpuTexture, render:Render2D, context3d:GpuContext, output:GpuRenderTarget, textureX:Number, textureY:Number):void
		{
			render.pushScreen(texture.width, texture.height);
			
			const prevBlendMode:BlendMode = context3d.blendMode;
			
			context3d.program = AssetMgr.Instance.getProgram(ShaderName.BLUR);
			context3d.blendMode = BlendMode.NORMAL;
			
			onDrawBegin(texture.width, texture.height);
			for(var i:int=0; i<numPasses; i++)
			{
				updateParameters(i, texture.width, texture.height);
				
				context3d.setVc(2, mOffsets, 1);
				context3d.setFc(0, mWeights, 1);
				
				swapBuffer();
				
				var gpuTexture:IGpuTexture = (0 == i ? texture : backBuffer);
				if(i + 1 < numPasses){
					context3d.renderTarget = frontBuffer;
					if(!frontBuffer.hasCleared()){
						context3d.clearStencil();
					}
					render.drawTexture(context3d, gpuTexture);
				}else{
					render.popScreen();
					context3d.renderTarget = output;
					render.drawTexture(context3d, gpuTexture, textureX, textureY);
				}
			}
			onDrawEnd();
			
			context3d.blendMode = prevBlendMode;
		}
		
		override public function get marginX():int
		{
			return Math.ceil(blurX) + 4;
		}
		
		override public function get marginY():int
		{
			return Math.ceil(blurX) + 4;
		}
		
		private function onDrawBegin(textureWidth:int, textureHeight:int):void
		{
			numPasses = Math.ceil(blurX) + Math.ceil(blurY);
			
			frontBuffer = new GpuRenderTarget(textureWidth, textureHeight);
			
			if(numPasses < 2){
				return;
			}
			
			backBuffer = new GpuRenderTarget(textureWidth, textureHeight);
		}
		
		private function onDrawEnd():void
		{
			if(frontBuffer != null){
				frontBuffer.dispose();
				frontBuffer = null;
			}
			
			backBuffer.dispose();
			backBuffer = null;
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
		
		private function updateParameters(pass:int, textureWidth:int, textureHeight:int):void
		{
			// algorithm described here: 
			// http://rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/
			// 
			// To run in constrained mode, we can only make 5 texture lookups in the fragment
			// shader. By making use of linear texture sampling, we can produce similar output
			// to what would be 9 lookups.
			
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