package snjdck.g2d.obj2d
{
	import snjdck.g2d.impl.Texture2D;
	import snjdck.gpu.GpuColor;
	import snjdck.gpu.asset.GpuAssetFactory;
	
	public class ColorQuad extends Image
	{
		static private const color:GpuColor = new GpuColor();
		
		public function ColorQuad(rgba:uint=0xFF000000)
		{
			super(new Texture2D(GpuAssetFactory.DefaultGpuTexture));
			color.value = rgba;
			setForegroundColor(color.rgb, color.alpha);
		}
	}
}