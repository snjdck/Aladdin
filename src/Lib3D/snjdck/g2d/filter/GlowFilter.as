package snjdck.g2d.filter
{
	import snjdck.gpu.GpuColor;

	public class GlowFilter extends FilterGroup2D
	{
		public function GlowFilter(blurX:Number, blurY:Number, color:uint=0xFFFF00, alpha:Number=1)
		{
			var gpuColor:GpuColor = new GpuColor(color);
			
			addFilter(new BlurFilter());
			addFilter(new ColorMatrixFilter());
		}
	}
}