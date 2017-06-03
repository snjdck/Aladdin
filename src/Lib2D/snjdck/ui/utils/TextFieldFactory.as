package snjdck.ui.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TextFieldFactory
	{
		static public function Create(parent:DisplayObjectContainer):TextField
		{
			var tf:TextField = new TextField();
			tf.defaultTextFormat = new TextFormat("微软雅黑", 12);
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.selectable = false;
			parent.addChild(tf);
			return tf;
		}
	}
}