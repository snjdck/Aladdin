package flash.bitmap
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public function drawString(value:String, output:BitmapData, bmdList:Object, bmdDict:String):void
	{
		const charCount:int = value.length;
		
		const rect:Rectangle = new Rectangle();
		const pt:Point = new Point();
		
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
}