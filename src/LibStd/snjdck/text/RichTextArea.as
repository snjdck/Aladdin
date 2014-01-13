package snjdck.text
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import lambda.apply;
	
	import string.replace;
	import string.replaceAt;
	
	public class RichTextArea extends Sprite
	{
		private const emotionDict:Object = {};
		private var tf:TextField;
		
		public function RichTextArea()
		{
			tf = new TextField();
			tf.wordWrap = true;
			addChild(tf);
		}
		
		public function regEmotion(id:String, factory:Object):void
		{
			emotionDict[id] = factory;
		}
		
		public function set htmlText(value:String):void
		{
			tf.htmlText = perform(value);
			update();
		}
		
		private function createEmotionUI(emotionId:String):DisplayObject
		{
			var factory:Object = emotionDict[emotionId];
			return lambda.apply(factory);
		}
		
		private function perform(info:String):String
		{
			var xml:XML = toXML(info);
			for each(var node:XML in xml.descendants("*")){
				if(node.nodeKind() != "text"){
					continue;
				}
				node.parent().replace(
					node.childIndex(),
					toXML(replaceEmotion(node.toString()))
				);
			}
			XML.prettyPrinting = false;
			return replace("<textformat leading='${0}'>${1}</textformat>", [10, xml.toXMLString()]);
		}
		
		private function replaceEmotion(source:String):String
		{
			var result:Array = matchEmotion(source);
			result.sortOn("charIndex", Array.NUMERIC|Array.DESCENDING);
			for each(var item:EmotionItem in result){
				var toIndex:int = item.charIndex + item.emotionId.length;
				source = replaceAt(source, item.charIndex, toIndex,
					replace("<font size='0'>${0}</font><font letterSpacing='${1}'>　</font>", [source.slice(item.charIndex, toIndex), 11])
				);
			}
			return source;
		}
		
		private function matchEmotion(source:String):Array
		{
			var result:Array = [];
			for(var emoteId:String in emotionDict){
				var charIndex:int = -1;
				while(true){
					charIndex = source.indexOf(emoteId, charIndex+1);
					if(charIndex < 0){
						break;
					}
					result.push(new EmotionItem(charIndex, emoteId));
				}
			}
			return result;
		}
		
		private function update():void
		{
			var result:Array = matchEmotion(tf.text);
			result.sortOn("charIndex", Array.NUMERIC);
			for each(var item:EmotionItem in result){
				item.emotionUI = createEmotionUI(item.emotionId);
				item.updateUI(tf);
				addChild(item.emotionUI);
			}
		}
		
		static private function toXML(source:String):XML
		{
			return XML("<span>" + source + "</span>");
		}
	}
}