package ui.popup
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import snjdck.gdi.drawBitmap;
	
	public class DisplayClip extends Sprite
	{
		public function DisplayClip(bmd:BitmapData, rect:Rectangle)
		{
			drawBitmap(graphics, bmd, 0, 0, rect.width, rect.height, rect.x, rect.y);
		}
	}
}