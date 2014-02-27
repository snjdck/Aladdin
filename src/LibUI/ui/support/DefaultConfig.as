package ui.support
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	
	import ui.button.Button;

	public class DefaultConfig
	{
		static public const FILTER_GRAY:BitmapFilter = new ColorMatrixFilter([
			0.299, 0.587, 0.114, 0, 0,
			0.299, 0.587, 0.114, 0, 0,
			0.299, 0.587, 0.114, 0, 0,
			0, 0, 0, 1, 0
		]);
		
//		[Embed(source="/assets/scroll_bar_up_arrow.png")]
		static private const SCROLL_BAR_UP_ARROW:Class;
		
//		[Embed(source="/assets/scroll_bar_down_arrow.png")]
		static private const SCROLL_BAR_DOWN_ARROW:Class;
		
		static private const SCROLL_BAR_WIDTH:int = 11;
		
		static public function createUpArrow():DisplayObject
		{
			var bmp:Bitmap = new SCROLL_BAR_UP_ARROW()
			bmp.x = (SCROLL_BAR_WIDTH - bmp.width) >> 1;
			return bmp;
		}
		
		static public function createDownArrow():DisplayObject
		{
			var bmp:Bitmap = new SCROLL_BAR_DOWN_ARROW();
			bmp.x = (SCROLL_BAR_WIDTH - bmp.width) >> 1;
			return bmp;
		}
		
		static public function createTrackUI():DisplayObject
		{
			return createBox(SCROLL_BAR_WIDTH, 100, 0xCCCCCC);
		}
		
		static public function createThumbBtn():DisplayObject
		{
			return createBox(SCROLL_BAR_WIDTH-2, 9, 0x333333, 1, 1);
		}
		
//		[Embed(source="assets/formation_closeButton_normal.png")]
//		static private const CLOSE_BUTTON_NORMAL:Class;
//		
//		[Embed(source="assets/formation_closeButton_pushed.png")]
//		static private const CLOSE_BUTTON_PUSHED:Class;
//		
//		[Embed(source="assets/formation_closeButton_highlight.png")]
//		static private const CLOSE_BUTTON_HIGHLIGHT:Class;
		
		static public function createCloseBtn():Button
		{
			var btn:Button = new Button();
//			btn.upSkin = new CLOSE_BUTTON_NORMAL();
//			btn.overSkin = new CLOSE_BUTTON_HIGHLIGHT();
//			btn.downSkin = new CLOSE_BUTTON_PUSHED();
			return btn;
		}
		
//		[Embed(source="/assets/vehicle_comboBox_rollButton_normal.png")]
		static private const COMBOBOX_POPUP_BUTTON_NORMAL:Class;
		
		static public function createComboBoxPopupBtn():Button
		{
			var btn:Button = new Button();
			btn.upSkin = new COMBOBOX_POPUP_BUTTON_NORMAL();
			return btn;
		}
		
//		[Embed(source="assets/formation_panel.png")]
//		static private const FRAME_BG:Class;
		
		static public function createFrameBg():DisplayObject
		{
			return new Sprite();
//			return new FRAME_BG;
		}
		
		static public function drawListBg(g:Graphics, x:Number, y:Number, width:Number, height:Number):void
		{
			g.beginFill(0x4F4E4D);
			drawRing(g, x, y, width, height);
			g.beginFill(0x000000);
			drawRing(g, x+1, y+1, width-2, height-2);
			g.beginFill(0x000000, 0.7);
			g.drawRect(x+2, y+2, width-4, height-4);
			g.endFill();
		}
		
		static private function drawRing(g:Graphics, x:Number, y:Number, width:Number, height:Number, offset:Number=1):void
		{
			g.drawRect(x, y, width, height);
			g.drawRect(x+offset, y+offset, width-offset*2, height-offset*2);
		}
	}
}