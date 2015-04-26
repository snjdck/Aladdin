package snjdck.g2d.util
{
	import snjdck.g2d.impl.DisplayObject2D;
	import snjdck.g2d.impl.DisplayObjectContainer2D;
	import snjdck.g2d.impl.Texture2D;
	import snjdck.g2d.obj2d.Image;
	import snjdck.gpu.asset.GpuAssetFactory;

	public class ImageUtil
	{
		static public function ImageFromBmp(bmCls:Class):Image
		{
			return new Image(new Texture2D(GpuAssetFactory.CreateGpuTexture2(new bmCls().bitmapData)));
		}
		
		static public function addChildren(parent:DisplayObjectContainer2D, ...childList):void
		{
			for each(var child:DisplayObject2D in childList){
				parent.addChild(child);
			}
		}
	}
}