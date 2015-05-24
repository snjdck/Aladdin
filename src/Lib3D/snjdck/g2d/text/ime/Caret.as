package snjdck.g2d.text.ime
{
	import snjdck.g2d.impl.Texture2D;
	import snjdck.g2d.obj2d.Image;
	import snjdck.gpu.asset.GpuAssetFactory;
	
	internal class Caret extends Image
	{
		public function Caret()
		{
			super(new Texture2D(GpuAssetFactory.DefaultGpuTexture));
			width = 2;
			height = 12;
		}
	}
}