package stdlib.bitmapdata
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
		
	public function bmd_alphaMerge(fg:BitmapData, bg:BitmapData, fgPos:Point, outputFg:BitmapData):void
	{
		const rect:Rectangle = new Rectangle(0, 0, fg.width, fg.height);
		const pt:Point = new Point(0, 0);
		
		outputFg.lock();
		outputFg.fillRect(rect, 0xFF000000);
		
		rect.x = fgPos.x;
		rect.y = fgPos.y;
		
		//将bg对应区域中不透明的的像素标记出来
		//不透明像素的alpha为0x80, 透明像素的alpha为0xFF
		outputFg.threshold(bg, rect, pt,
			">", 0x00000000, 0x80000000,
			0xFF000000
		);
		
		rect.x = 0;
		rect.y = 0;
		
		outputFg.copyPixels(fg, rect, pt, outputFg);
		outputFg.unlock();
	}
}