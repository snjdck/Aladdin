package ui.popup
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import org.xmlui.button.Button;
	
	public class CloseButton extends Button
	{
//		[Embed(source="F:/ProgramData/MU1_03H_full(Chs)/ui/comp/btn_close.png")]
		static private const skinCls:Class;
		static private const skin:BitmapData = new skinCls().bitmapData;
		
		public function CloseButton()
		{
			var rect:Rectangle = new Rectangle(0, 0, skin.width, skin.height / 3);
			upSkin = new DisplayClip(skin, rect);
			rect.y = skin.height / 3;
			overSkin = new DisplayClip(skin, rect);
			rect.y *= 2;
			downSkin = new DisplayClip(skin, rect);
			
			this.width = skin.width;
			this.height = skin.height / 3;
		}
	}
}