package snjdck.ui.menu
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	internal class DrawTool
	{
		static public function DrawMenuBG(g:Graphics, w:Number, h:Number):void
		{
			g.clear();
			g.beginFill(0x999999);
			g.drawRect(-1,-1,w+2,h+2);
			g.drawRect(0,0,w,h);
			g.endFill();
			g.beginFill(0xFFFFFF);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		
		static public function DrawMenuItemBG(g:Graphics, w:Number, h:Number, color:uint=0, alpha:Number=0):void
		{
			g.clear();
			g.beginFill(color, alpha);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		
		static public function CreateTextField(parent:DisplayObjectContainer):TextField
		{
			var tf:TextField = new TextField();
			tf.defaultTextFormat = new TextFormat("宋体", 12);
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.selectable = false;
			parent.addChild(tf);
			return tf;
		}
		
		static public function CreateIcon():DisplayObject
		{
			var sp:Shape = new Shape();
			var g:Graphics = sp.graphics;
			
			var size:int = 3;
			g.lineStyle(0);
			g.moveTo(0, 0);
			g.lineTo(size, size);
			g.lineTo(0, size * 2);
			
			return sp;
		}
	}
}