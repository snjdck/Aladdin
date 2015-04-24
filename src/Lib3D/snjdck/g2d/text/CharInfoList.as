package snjdck.g2d.text
{
	import flash.geom.Rectangle;
	import flash.support.ObjectPool;
	
	internal class CharInfoList
	{
		private const pool:ObjectPool = new ObjectPool(CharInfo);
		private const list:Vector.<CharInfo> = new Vector.<CharInfo>();
		
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
			pool.recyleUsedItems();
			list.length = 0;
		}
		
		public function push(info:Rectangle):void
		{
			var charInfo:CharInfo = pool.getObjectOut();
			charInfo.uv = info;
			list.push(charInfo);
		}
		
		public function arrange(maxWidth:int, maxHeight:int):void
		{
			var offsetX:int, offsetY:int;
			var charCount:int = list.length;
			for(var i:int=0; i<charCount; ++i){
				var charInfo:CharInfo = list[i];
				if(offsetX + charInfo.width > maxWidth){
					offsetY += charInfo.height;
					offsetX = 0;
				}
				if(offsetY + charInfo.height > maxHeight){
					list.splice(i, charCount);
					return;
				}
				charInfo.x = offsetX;
				charInfo.y = offsetY;
				offsetX += charInfo.width;
			}
		}
	}
}