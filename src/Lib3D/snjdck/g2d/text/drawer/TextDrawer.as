package snjdck.g2d.text.drawer
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TextDrawer
	{
		private var tf:TextField;
		
		public function TextDrawer(fontSize:int)
		{
			tf = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.defaultTextFormat = new TextFormat("宋体", fontSize, 0xFFFFFF);
		}
		
		public function clear():void
		{
			tf.text = "";
		}
		
		public function appendText(value:String):void
		{
			tf.appendText(value);
		}
		
		public function isHalfChar(char:String):Boolean
		{
			sizeChecker.text = char;
			return (sizeChecker.textWidth << 1) <= sizeChecker.textHeight;
		}
		
		static private const sizeChecker:TextField = new TextField();
		static private const matrix:Matrix = new Matrix();
		
		public function draw(output:BitmapData, offsetX:int, offsetY:int):void
		{
			matrix.tx = offsetX - 2;
			matrix.ty = offsetY - 2;
			output.draw(tf, matrix, null, null, null, true);
		}
	}
}