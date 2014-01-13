package snjdck.text
{
	import flash.display.Sprite;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	
	public class NativeLabel extends Sprite
	{
		private var textBlock:TextBlock;
		private var fontDescription:FontDescription;
		private var elementFormat:ElementFormat;
		private var textElement:TextElement;
		
		private var textLinePool:Vector.<TextLine>;
		private var textLineList:Vector.<TextLine>;
		
		public function NativeLabel()
		{
			textLinePool = new Vector.<TextLine>();
			textLineList = new Vector.<TextLine>();
			fontDescription = new FontDescription("Arial,宋体");
			elementFormat = new ElementFormat(fontDescription);
			textElement = new TextElement(null, elementFormat);
			textBlock = new TextBlock(textElement);
		}
		
		private function updateFontDescription():void
		{
			elementFormat = elementFormat.clone();
			elementFormat.fontDescription = fontDescription;
			updateElementFormat();
		}
		
		private function updateElementFormat():void
		{
			textElement.elementFormat = elementFormat;
		}
		
		public function set bold(val:Boolean):void
		{
			fontDescription = fontDescription.clone();
			fontDescription.fontWeight = val ? FontWeight.BOLD : FontWeight.NORMAL;
			updateFontDescription();
			redraw();
		}
		
		public function set italic(val:Boolean):void
		{
			fontDescription = fontDescription.clone();
			fontDescription.fontPosture = val ? FontPosture.ITALIC : FontPosture.NORMAL;
			updateFontDescription();
			redraw();
		}
		
		public function set fontSize(val:Number):void
		{
			elementFormat = elementFormat.clone();
			elementFormat.fontSize = val;
			updateElementFormat();
			redraw();
		}
		
		public function set fontColor(color:uint):void
		{
			elementFormat = elementFormat.clone();
			elementFormat.color = color;
			updateElementFormat();
			redraw();
		}
		
		public function set text(val:String):void
		{
			textElement.text = val;
			redraw();
		}
		
		private function redraw():void
		{
			while(textLineList.length > 0){
				textLinePool.push(textLineList.pop());
			}
			removeChildren();
			onUpdate();
			addChildren();
		}
		
		private function onUpdate():void
		{
			var lineWidth:Number = 300;
			var yPos:Number = 0;
			
			var textLine:TextLine;
			
			while(true){
				if(textLinePool.length > 0){
					textLine = textBlock.recreateTextLine(textLinePool.pop(), textLine, lineWidth);
				}else{
					textLine = textBlock.createTextLine(textLine, lineWidth);
				}
				if(null == textLine){
					break;
				}
				textLine.y = yPos;
				yPos += textLine.height + 2;
				textLineList.push(textLine);
			}
		}
		
		private function addChildren():void
		{
			var textLine:TextLine = textBlock.firstLine;
			
			while(textLine){
				if(textLine.parent != this){
					addChild(textLine);
				}
				textLine = textLine.nextLine;
			}
		}
	}
}