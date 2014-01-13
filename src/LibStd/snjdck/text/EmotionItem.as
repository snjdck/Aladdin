package snjdck.text
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;

	[ExcludeClass]
	internal class EmotionItem
	{
		public var charIndex:int;
		public var emotionId:String;
		
		public var emotionUI:DisplayObject;
		
		public function EmotionItem(charIndex:int, emotionId:String)
		{
			this.charIndex = charIndex;
			this.emotionId = emotionId;
		}
		
		public function updateUI(tf:TextField):void
		{
			var rect:Rectangle = tf.getCharBoundaries(charIndex);
			
			var emotionX:Number = rect.x;
			var emotionY:Number = rect.y + (rect.height - emotionUI.height) * 0.5;
			
			if(rect.x + emotionUI.width > tf.width)
			{
				var lineMetrics:TextLineMetrics = tf.getLineMetrics(tf.getLineIndexOfChar(charIndex));
				emotionX = 0;
				emotionY += lineMetrics.height;
			}
			
			emotionUI.x = emotionX;
			emotionUI.y = emotionY;
		}
	}
}