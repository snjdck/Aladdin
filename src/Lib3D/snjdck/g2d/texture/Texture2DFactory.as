package snjdck.g2d.texture
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import math.isPowerOfTwo;
	import math.nextPowerOfTwo;
	
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.asset.GpuAssetFactory;
	import snjdck.g2d.core.ITexture2D;

	public class Texture2DFactory
	{
		static public function Create():ITexture2D
		{
			return null;
		}
		
		static public function CreateFromBitmap(data:Bitmap, scale:Number=1):ITexture2D
		{
			return CreateFromBitmapData(data.bitmapData, scale);
		}
		
		static public function CreateFromBitmapData(data:BitmapData, scale:Number=1):ITexture2D
		{
			var result:Texture2D;
			var rawData:IGpuTexture;
			
			if(isPowerOfTwo(data.width) && isPowerOfTwo(data.height)){
				rawData = GpuAssetFactory.CreateGpuTexture2(data);
				result = new Texture2D(rawData);
				return result;
			}
			
			var width:int = nextPowerOfTwo(data.width);
			var height:int = nextPowerOfTwo(data.height);
			
			var bmd:BitmapData = new BitmapData(width, height, true, 0);
			bmd.copyPixels(data, data.rect, new Point());
			rawData = GpuAssetFactory.CreateGpuTexture2(bmd);
			
			return new SubTexture2D(new Texture2D(rawData), new Rectangle(0, 0, data.width, data.height));
		}
	}
}