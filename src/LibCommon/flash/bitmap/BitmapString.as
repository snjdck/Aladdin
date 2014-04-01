package flash.bitmap
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	final public class BitmapString
	{
		private var bmdList:Object;
		private var bmdDict:String;
		
		public function BitmapString(bmdList:Object, bmdDict:String)
		{
			this.bmdList = bmdList;
			this.bmdDict = bmdDict;
		}
		
		public function drawToBitmap(value:String, output:BitmapData):void
		{
			const charCount:int = value.length;
			pt.setTo(0, 0);
			
			for(var i:int=0; i<charCount; i++)
			{
				var char:String = value.charAt(i);
				var charIndex:int = bmdDict.indexOf(char);
				if (charIndex < 0) continue;
				var bmd:BitmapData = bmdList[charIndex];
				
				rect.width = bmd.width;
				rect.height = bmd.height;
				output.copyPixels(bmd, rect, pt);
				
				pt.x += rect.width;
			}
		}
		
		public function drawToGraphics(value:String, graphics:Graphics):void
		{
			const charCount:int = value.length;
			pt.setTo(0, 0);
			
			for(var i:int=0; i<charCount; i++)
			{
				var char:String = value.charAt(i);
				var charIndex:int = bmdDict.indexOf(char);
				if (charIndex < 0) continue;
				var bmd:BitmapData = bmdList[charIndex];
				
				matrix.tx = pt.x;
				matrix.ty = pt.y;
				graphics.beginBitmapFill(bmd, matrix);
				graphics.drawRect(pt.x, pt.y, bmd.width, bmd.height);
				graphics.endFill();
				
				pt.x += rect.width;
			}
		}
		
		static private const matrix:Matrix = new Matrix();
		static private const rect:Rectangle = new Rectangle();
		static private const pt:Point = new Point();
	}
}