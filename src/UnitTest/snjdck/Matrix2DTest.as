package snjdck
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.profiler.calcFuncExecTime;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import matrix33.compose;
	
	public class Matrix2DTest extends Sprite
	{
		private var tf:TextField = new TextField();
		private var testCount:int = 100000;
		
		public function Matrix2DTest()
		{
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.defaultTextFormat = new TextFormat("宋体", 12);
			addChild(tf);
			stage.addEventListener(MouseEvent.CLICK, __onClick);
		}
		
		private function __onClick(event:MouseEvent):void
		{
			var a:Number = calcFuncExecTime(testA, null, testCount);
			var b:Number = calcFuncExecTime(testB, null, testCount);
			tf.text = "";
			tf.appendText(a.toString());
			tf.appendText("\n");
			tf.appendText(b.toString());
		}
		
		private var matrixA:Matrix = new Matrix();
		private var matrixB:Matrix = new Matrix();
		
		private function testA():void
		{
			matrixA.identity();
			matrixA.scale(3.5, 5.2);
			matrixA.rotate(0);
			matrixA.translate(6.8, 10.1);
		}
		
		private function testB():void
		{
//			compose(matrixB, 3.5, 5.2, 0, 6.8, 10.1);
		}
	}
}