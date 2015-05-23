package snjdck.g2d.text.ime
{
	import flash.geom.Rectangle;
	import flash.text.ime.CompositionAttributeRange;
	import flash.text.ime.IIMEClient;
	
	public class IMEClient implements IIMEClient
	{
		private var textBounds:Rectangle;
		
		public function IMEClient()
		{
			textBounds = new Rectangle(0, 0, 12, 12);
		}
		
		public function get compositionEndIndex():int
		{
			return 0;
		}
		
		public function get compositionStartIndex():int
		{
			return 0;
		}
		
		public function confirmComposition(text:String=null, preserveSelection:Boolean=false):void
		{
		}
		
		public function getTextBounds(startIndex:int, endIndex:int):Rectangle
		{
//			trace("getTextBounds", startIndex, endIndex);
			return textBounds;
		}
		
		public function getTextInRange(startIndex:int, endIndex:int):String
		{
//			trace("getTextInRange", startIndex, endIndex);
			return null;
		}
		
		public function selectRange(anchorIndex:int, activeIndex:int):void
		{
//			trace("selectRange", anchorIndex, activeIndex);
		}
		
		public function updateComposition(text:String, attributes:Vector.<CompositionAttributeRange>, compositionStartIndex:int, compositionEndIndex:int):void
		{
//			trace("updateComposition", text, attributes.length, compositionStartIndex, compositionEndIndex);
//			for(var i:int=0; i<attributes.length; ++i){
//				var item:CompositionAttributeRange = attributes[i];
//				trace(item.converted, item.relativeStart, item.relativeEnd, item.selected);
//			}
		}
		
		public function get selectionActiveIndex():int
		{
//			trace("selectionActiveIndex");
			return 0;
		}
		
		public function get selectionAnchorIndex():int
		{
//			trace("selectionAnchorIndex");
			return 0;
		}
		
		public function get verticalTextLayout():Boolean
		{
			return false;
		}
	}
}