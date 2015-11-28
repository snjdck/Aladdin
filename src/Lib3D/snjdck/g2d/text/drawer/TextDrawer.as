package snjdck.g2d.text.drawer
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TextDrawer
	{
		static public const FONT_SIZE:int = 32;
		
		private const matrix:Matrix = new Matrix();
		private var tf:TextField;
		private var format:TextFormat;
		private var sdf:SignedDistanceField;
		static public const spread:Number = 4;
		
		public function TextDrawer()
		{
			tf = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			format = new TextFormat("宋体", FONT_SIZE - spread * 2, 0xFFFFFF);
			format.letterSpacing = spread;
			tf.defaultTextFormat = format;
			
			sdf = new SignedDistanceField(spread);
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
			rect.width = rect.height = FONT_SIZE;
			rect.offset(-2, -2);
			trace(rect.x, rect.y, rect.width, format.size);
			rect.x *= FONT_SIZE / int(format.size+format.letterSpacing);
			rect.y *= FONT_SIZE / int(format.size+format.letterSpacing);
			trace(rect.x, rect.y, rect.width, format.size);
			return rect;
		}
		
		public function draw(output:BitmapData, offsetX:int, offsetY:int):void
		{
//			matrix.a = matrix.d = 1;
			matrix.tx = matrix.ty = spread - 2;
			var bmd:BitmapData = new BitmapData(spread * 2 + tf.textWidth, spread * 2 + tf.textHeight, false, 0);
			trace(bmd.width, bmd.height);
			bmd.draw(tf, matrix);
			
			var newBmd:BitmapData = sdf.gen(bmd);
			
//			matrix.a = matrix.d = 0.5;
			matrix.tx = offsetX;
			matrix.ty = offsetY;
			output.draw(newBmd, matrix, null, null, null, true);
//			output.draw(tf);
			
			bmd.dispose();
			newBmd.dispose();
		}
	}
}