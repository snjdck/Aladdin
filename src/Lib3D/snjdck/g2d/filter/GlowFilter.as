package snjdck.g2d.filter
{
	import snjdck.gpu.GpuColor;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuRenderTarget;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.asset.helper.AssetMgr;
	import snjdck.gpu.asset.helper.ShaderName;
	import snjdck.gpu.render.GpuRender;

	public class GlowFilter extends FilterGroup2D
	{
		public function GlowFilter(blurX:Number, blurY:Number, color:uint=0xFFFF00, alpha:Number=1)
		{
			var gpuColor:GpuColor = new GpuColor(color);
			
			addFilter(new BlurFilter(blurX, blurY));
			addFilter(new ColorMatrixFilter(new <Number>[
				0, 0, 0, 0,
				0, 0, 0, 0,
				0, 0, 0, 0,
				0, 0, 0, alpha,
				gpuColor.red, gpuColor.green, gpuColor.blue, 0
			]));
		}
		
		override public function renderFilter(texture:IGpuTexture, render:GpuRender, context3d:GpuContext, output:GpuRenderTarget, textureX:Number, textureY:Number):void
		{
			super.renderFilter(texture, render, context3d, output, textureX, textureY);
			context3d.program = AssetMgr.Instance.getProgram(ShaderName.TEXTURE);
			render.r2d.drawTexture(context3d, texture, textureX, textureY);
		}
	}
}