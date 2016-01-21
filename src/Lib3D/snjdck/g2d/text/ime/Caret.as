package snjdck.g2d.text.ime
{
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.impl.Texture2D;
	import snjdck.g2d.obj2d.Image;
	import snjdck.gpu.asset.GpuAssetFactory;
	
	use namespace ns_g2d;
	
	internal class Caret extends Image
	{
		public function Caret()
		{
			super(new Texture2D(GpuAssetFactory.DefaultGpuTexture));
			originalBound.setTo(0, 0, 2, 12);
			markOriginalBoundDirty();
		}
	}
}