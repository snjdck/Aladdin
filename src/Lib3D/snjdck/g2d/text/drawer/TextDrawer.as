package snjdck.g2d.text.drawer
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TextDrawer
	{
		private const matrix:Matrix = new Matrix();
		private var tf:TextField;
		
		public function TextDrawer()
		{
			tf = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.defaultTextFormat = new TextFormat("宋体", 16, 0xFF0000);
		}
		
		public function get textWidth():int
		{
			return tf.textWidth;
		}
		
		public function get textHeight():int
		{
			return tf.textHeight;
		}
		
		public function setText(value:String):void
		{
			tf.text = value;
		}
		
		public function draw(output:BitmapData, offsetX:int, offsetY:int):void
		{
			matrix.tx = offsetX - 2;
			matrix.ty = offsetY - 2;
			output.draw(tf, matrix);
		}
	}
}