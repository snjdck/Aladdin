package snjdck.g2d.text.drawer
{
	import flash.display.BitmapData;
	import flash.filters.BitmapFilterType;
	import flash.filters.GradientGlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TextDrawer
	{
		static public const FontSize:int = 16;
		
		private const matrix:Matrix = new Matrix();
		private var tf:TextField;
		
		public function TextDrawer()
		{
			tf = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.defaultTextFormat = new TextFormat("宋体", FontSize, 0xFFFFFF);
			tf.filters = [
				new GradientGlowFilter(0, 0, [0, 0xFFFFFF], [0, 1], [0, 128], 2, 2, 1, 1, BitmapFilterType.OUTER)
			];
		}
		
		public function clear():void
		{
			tf.text = "";
		}
		
		public function get textWidth():int
		{
			return tf.textWidth;
		}
		
		public function get textHeight():int
		{
			return tf.textHeight;
		}
		
		public function removeLastChar():void
		{
			var index:int = tf.text.length;
			tf.replaceText(index-1, index, "");
		}
		
		
		/*
		public function insertText(index:int, value:String):void
		{
			if(index < 0){
				index += tf.text.length;
			}
			tf.replaceText(index, index, value);
		}
		//*/
		public function setText(value:String):void
		{
			tf.text = value;
		}
		
		public function appendText(value:String):void
		{
			tf.appendText(value);
		}
		
		public function getCharBoundaries(charIndex:int):Rectangle
		{
			var rect:Rectangle = tf.getCharBoundaries(charIndex);
			rect.width = rect.height;
			rect.offset(-2, -2);
			return rect;
		}
		
		public function draw(output:BitmapData, offsetX:int, offsetY:int):void
		{
			matrix.tx = offsetX - 2;
			matrix.ty = offsetY - 2;
			output.draw(tf, matrix, null, null, null, true);
		}
	}
}