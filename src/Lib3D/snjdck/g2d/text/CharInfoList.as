package snjdck.g2d.text
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.support.ObjectPool;
	
	import snjdck.g2d.ns_g2d;
	
	use namespace ns_g2d;
	
	internal class CharInfoList
	{
		private const pool:ObjectPool = new ObjectPool(CharInfo);
		private const list:Vector.<CharInfo> = new Vector.<CharInfo>();
		private var label:Label;
		
		private var numRows:int;
		private var offsetX:int;
		private var offsetY:int;
		
		public function CharInfoList(label:Label)
		{
			this.label = label;
		}
		
		public function get charCount():int
		{
			return list.length;
		}
		
		public function getCharAt(index:int):CharInfo
		{
			return list[index];
		}
		
		public function clear():void
		{
			offsetX = 2;
			offsetY = 2 - label.scrollV * label.fontSize;
			numRows = 0;
			while(list.length > 0){
				pool.setObjectIn(list.pop());
			}
		}
		
		public function push(info:Rectangle):void
		{
			var charInfo:CharInfo = pool.getObjectOut();
			charInfo.uv = info;
			
			if(offsetX + label.fontSize > label.width){
				pushNewline();
			}
			label._numLines = numRows + 1;
			label._maxScrollV = numRows + 1 - label.visibleLines;
			if(offsetY + label.fontSize > label.height){
				pool.setObjectIn(charInfo);
			}else{
				label._bottomScrollV = numRows;
				charInfo.numRow = numRows - label.scrollV;
				
				if(charInfo.numRow < 0){
					pool.setObjectIn(charInfo);
					return;
				}
				charInfo.x = offsetX;
				charInfo.y = offsetY;
				list.push(charInfo);
			}
			offsetX += charInfo.width;
		}
		
		public function calcPosition(text:String, caretIndex:int, maxWidth:int, result:Point):void
		{
			if(list.length <= 0){
				result.setTo(2, 2);
				return;
			}
			var charInfo:CharInfo;
			if(caretIndex < list.length){
				charInfo = list[caretIndex];
				result.x = charInfo.x;
				result.y = charInfo.y;
			}else{
				charInfo = list[list.length - 1];
				result.x = charInfo.x + charInfo.width;
				result.y = charInfo.y;
			}
		}
		
		private function getCharInfo(caretIndex:int):CharInfo
		{
			if(list.length <= 0){
				return null;
			}
			if(caretIndex < list.length){
				return list[caretIndex];
			}
			return list[list.length - 1];
		}
		
		ns_g2d function moveCaretUp(caretIndex:int):int
		{
			var caretCharInfo:CharInfo = getCharInfo(caretIndex);
			if(null == caretCharInfo){
				return caretIndex;
			}
			var numRow:int = caretCharInfo.numRow - 1;
			if(numRow < 0){
				return caretIndex;
			}
			for(var i:int=0; i<list.length; ++i){
				var charInfo:CharInfo = list[i];
				if(charInfo.numRow != numRow){
					continue;
				}
				if(charInfo.x + charInfo.width > caretCharInfo.x){
					return i;
				}
			}
			return caretIndex;
		}
		
		ns_g2d function moveCaretDown(caretIndex:int):int
		{
			var caretCharInfo:CharInfo = getCharInfo(caretIndex);
			if(null == caretCharInfo){
				return caretIndex;
			}
			var numRow:int = caretCharInfo.numRow + 1;
			if(numRow > numRows){
				return caretIndex;
			}
			for(var i:int=0; i<list.length; ++i){
				var charInfo:CharInfo = list[i];
				if(charInfo.numRow != numRow){
					continue;
				}
				if(charInfo.x + charInfo.width > caretCharInfo.x){
					return i;
				}
			}
			return list.length;
		}
		
		public function pushNewline():void
		{
			++numRows;
			offsetY += label.fontSize;
			offsetX = 2;
		}
		
		public function pushTab():void
		{
			offsetX += label.fontSize << 1;
		}
		
		public function pushBlank():void
		{
			offsetX += label.fontSize >> 1;
		}
	}
}