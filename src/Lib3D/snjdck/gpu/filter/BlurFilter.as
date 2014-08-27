package snjdck.gpu.filter
{
	import flash.geom.Rectangle;
	
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.support.VertexData;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.GpuRender;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.asset.helper.AssetMgr;

	public class BlurFilter extends FragmentFilter
	{
		static private const _vertexData:VertexData = new VertexData();
		
		public var blurX:Number = 4;
		public var blurY:Number = 4;
		
		private var frontBuffer:GpuRenderTarget;
		private var backBuffer:GpuRenderTarget;
		
		private var bounds:Rectangle = new Rectangle();
		
		public function BlurFilter()
		{
			mode = FragmentFilterMode.BELOW;
		}
		
		public function calcBounds(target:IDisplayObject2D):void
		{
			target.getBounds(target.parent, bounds);
			bounds.inflate(
				Math.ceil(blurX) * 0.5 + 2,
				Math.ceil(blurY) * 0.5 + 2
			);
		}
		
		public function swapBuffer():void
		{
			var temp:GpuRenderTarget = frontBuffer;
			frontBuffer = backBuffer;
			backBuffer = temp;
		}
		
		override public function draw(target:DisplayObject2D, render:GpuRender, context3d:GpuContext):void
		{
			if(FragmentFilterMode.ABOVE == mode){
				target.draw(render, context3d);
				render.r2d.drawEnd(context3d);
			}
			
			calcBounds(target);
			
			frontBuffer = new GpuRenderTarget(bounds.width, bounds.height);
			backBuffer = new GpuRenderTarget(bounds.width, bounds.height);
			
			render.r2d.pushScreen();
			render.r2d.setScreenSize(bounds.width, bounds.height);
			render.r2d.offset(-bounds.x, -bounds.y);
			render.r2d.uploadProjectionMatrix(context3d);
			render.r2d.popScreen();
			
			var lastRenderTarget:GpuRenderTarget = context3d.currentRenderTarget;
			
			context3d.setRenderToTexture(frontBuffer);
			frontBuffer.clear(context3d);
			
			target.draw(render, context3d);
			render.r2d.drawEnd(context3d);
			
			prepare(render, context3d);
			
			context3d.setRenderToTexture(lastRenderTarget);
			render.r2d.uploadProjectionMatrix(context3d);
			
			render.r2d.drawBegin(context3d);
			_vertexData.reset(bounds.x, bounds.y, bounds.width, bounds.height);
			render.r2d.drawTexture(context3d, _vertexData, frontBuffer);
			render.r2d.drawEnd(context3d);
			
			if(FragmentFilterMode.BELOW == mode){
				target.draw(render, context3d);
				render.r2d.drawEnd(context3d);
			}
			
			frontBuffer.dispose();
			backBuffer.dispose();
		}
		
		public function prepare(render:GpuRender, context3d:GpuContext):void
		{
			_vertexData.reset(0, 0, bounds.width, bounds.height);
			
			render.r2d.pushScreen();
			render.r2d.setScreenSize(bounds.width, bounds.height);
			render.r2d.uploadProjectionMatrix(context3d);
			render.r2d.popScreen();
			
			context3d.setProgram(AssetMgr.Instance.getProgram("blur"));
			context3d.setBlendFactor(BlendMode.NORMAL);
			
			var numPasses:int = Math.ceil(blurX) + Math.ceil(blurY);
			
			for(var i:int=0; i<numPasses; i++)
			{
				updateParameters(i, bounds.width, bounds.height);
				
				context3d.setVc(4, mOffsets, 1);
				context3d.setFc(1, mWeights, 1);
				
				swapBuffer();
				
				context3d.setRenderToTexture(frontBuffer);
				frontBuffer.clear(context3d);
				
				if(i == numPasses - 1){
					context3d.setProgram(AssetMgr.Instance.getProgram("blur_tint"));
					context3d.setFc(2, mColor, 1);
				}
				
				render.r2d.drawTexture(context3d, _vertexData, backBuffer);
				render.r2d.drawEnd(context3d);
			}
		}
		
		private static const MAX_SIGMA:Number = 2.0;
		private var sTmpWeights:Vector.<Number> = new Vector.<Number>(5, true);
		
		private var mOffsets:Vector.<Number> = new <Number>[0, 0, 0, 0];
		private var mWeights:Vector.<Number> = new <Number>[0, 0, 0, 0];
		private var mColor:Vector.<Number>   = new <Number>[1, 1, 1, 1];
		
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