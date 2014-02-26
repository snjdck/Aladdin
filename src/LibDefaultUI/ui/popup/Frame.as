package ui.popup
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import org.xmlui.button.Button;
	
	import snjdck.signal.Signal;
	import flash.display.Scale9GridDrawer;
	
	import ui.core.Container;
	
	public class Frame extends Container
	{
		static public const BUTTON_CLOSE:int = 1;
		
//		[Embed(source="F:/ProgramData/MU1_03H_full(Chs)/ui/comp/bg.png")]
		static private const bgCls:Class;
		static private var bg:BitmapData = new bgCls().bitmapData;
		
		private var closeBtn:Button;
		public const closedSignal:Signal = new Signal(int);
		
		private var infoLabel:TextField;
		
		public function Frame()
		{
			super();
			infoLabel = new TextField();
			addChild(infoLabel);
			infoLabel.width = 250;
			infoLabel.height = 100;
			infoLabel.y = 25;
			infoLabel.autoSize = TextFieldAutoSize.CENTER;
			
			closeBtn = new CloseButton();
			closeBtn.y = 3;
			addChild(closeBtn);
			
			closeBtn.addEventListener(MouseEvent.CLICK, __onClose);
			
			width = 250;
			height = 150;
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			drawBg(width, height);
			closeBtn.x = width - closeBtn.width - 6;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			drawBg(width, height);
		}
		
		private function drawBg(w:int, h:int):void
		{
			Scale9GridDrawer.Draw(graphics, bg, 0, 0, w, h, new Rectangle(4, 30, 92, 45));
		}
		
		public function setInfo(info:String):void
		{
			infoLabel.htmlText = info;
		}
		
		private function __onClose(evt:MouseEvent):void
		{
			closedSignal.notify(BUTTON_CLOSE);
		}
		
		static public function createBox(w:int, h:int, color:uint):Sprite
		{
			var sp:Sprite = new Sprite();
			var g:Graphics = sp.graphics;
			
			g.beginFill(color);
			g.drawRect(0,0,w,h);
			g.endFill();
			return sp;
		}
	}
}