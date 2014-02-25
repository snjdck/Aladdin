package ui.popup
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import snjdck.GDI;
	
	public class DisplayClip extends Sprite
	{
		public function DisplayClip(bmd:BitmapData, rect:Rectangle)
		{
			GDI.drawBitmap(graphics, bmd, 0, 0, rect.width, rect.height, rect.x, rect.y);
		}
	}
}