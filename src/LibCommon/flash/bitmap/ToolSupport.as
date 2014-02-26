package flash.bitmap
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.JPEGEncoder;

	public class ToolSupport
	{
		static public function generateColorAlphaImage(sourceData:BitmapData, colorQuality:Number, alphaQuality:Number):Array
		{
			var colorData:BitmapData = generateColorImage(sourceData);
			var alphaData:BitmapData = generateAlphaImage(sourceData);
			
			var colorBytes:ByteArray = new JPEGEncoder(colorQuality).encode(colorData);
			var alphaBytes:ByteArray = new JPEGEncoder(alphaQuality).encode(alphaData);
			
			colorData.dispose();
			alphaData.dispose();
			
			return [colorBytes, alphaBytes];
		}
		
		static public function mergeColorAlphaImage(colorData:BitmapData, alphaData:BitmapData):BitmapData
		{
			sourceRect.setTo(0, 0, colorData.width, colorData.height);
			
			var result:BitmapData = new BitmapData(colorData.width, colorData.height, true, 0);
			
			result.copyPixels(colorData, sourceRect, destPoint);
			result.copyChannel(alphaData, sourceRect, destPoint, BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
			
			return result;
		}
		
		static public function generateColorImage(sourceData:BitmapData):BitmapData
		{
			sourceRect.setTo(0, 0, sourceData.width, sourceData.height);
			
			var colorData:BitmapData = new BitmapData(sourceData.width, sourceData.height, false, 0);
			
			colorData.copyPixels(sourceData, sourceRect, destPoint);
			
			return colorData;
		}
		
		static public function generateAlphaImage(sourceData:BitmapData):BitmapData
		{
			sourceRect.setTo(0, 0, sourceData.width, sourceData.height);
			
			var alphaData:BitmapData = new BitmapData(sourceData.width, sourceData.height, false, 0);
			
			alphaData.copyChannel(sourceData, sourceRect, destPoint, BitmapDataChannel.ALPHA, BitmapDataChannel.RED);
			alphaData.copyChannel(sourceData, sourceRect, destPoint, BitmapDataChannel.ALPHA, BitmapDataChannel.GREEN);
			alphaData.copyChannel(sourceData, sourceRect, destPoint, BitmapDataChannel.ALPHA, BitmapDataChannel.BLUE);
			
			return alphaData;
		}
		
		static private const sourceRect:Rectangle = new Rectangle();
		static private const destPoint:Point = new Point();
	}
}