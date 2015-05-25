package snjdck.g2d.text
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.support.ObjectPool;
	
	import snjdck.g2d.ns_g2d;
	
	internal class CharInfoList
	{
		static private const pool:ObjectPool = new ObjectPool(CharInfo);
		private const list:Vector.<CharInfo> = new Vector.<CharInfo>();
		private var numRows:int;
		
		public function CharInfoList(){}
		
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
			while(list.length > 0){
				pool.setObjectIn(list.pop());
			}
		}
		
		public function push(info:Rectangle):void
		{
			var charInfo:CharInfo = pool.getObjectOut();
			charInfo.uv = info;
			list.push(charInfo);
		}
		
		public function arrange(maxWidth:int, maxHeight:int):void
		{
			var offsetX:int = 2;
			var offsetY:int = 2;
			numRows = 0;
			var charCount:int = list.length;
			for(var i:int=0; i<charCount; ++i){
				var charInfo:CharInfo = list[i];
				if(offsetX + charInfo.width > maxWidth){
					offsetY += charInfo.height + 4;
					offsetX = 2;
					++numRows;
				}
				if(offsetY + charInfo.height > maxHeight){
					list.splice(i, charCount);
					return;
				}
				charInfo.x = offsetX;
				charInfo.y = offsetY;
				charInfo.numRow = numRows;
				offsetX += charInfo.width;
			}
		}
		
		public function calcPosition(text:String, caretIndex:int, maxWidth:int, result:Point):void
		{
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
			if(caretIndex < list.length){
				return list[caretIndex];
			}
			return list[list.length - 1];
		}
		
		ns_g2d function moveCaretUp(caretIndex:int):int
		{
			var caretCharInfo:CharInfo = getCharInfo(caretIndex);
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
	}
}