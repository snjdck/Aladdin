package stdlib.bitmapdata
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public function bmd_generateString(value:String, output:BitmapData, bmdList:Object, bmdDict:String):void
	{
		const charCount:int = value.length;
		const bmd:BitmapData = bmdList[0];
		
		const rect:Rectangle = new Rectangle(0, 0, bmd.width, bmd.height);
		const pt:Point = new Point(0, 0);
		
		for(var i:int=0; i<charCount; i++)
		{
			var char:String = value.charAt(i);
			var index:int = bmdDict.indexOf(char);
			if(-1 != index){
				output.copyPixels(bmdList[index], rect, pt);
			}
			pt.x += rect.width;
		}
	}
}