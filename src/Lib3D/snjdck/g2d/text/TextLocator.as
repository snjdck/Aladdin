package snjdck.g2d.text
{
	import flash.geom.Rectangle;

	internal class TextLocator
	{
		private var rectSize:int;
		private var charSize:int;
		
		private var maxCount:int;
		private var rowCount:int;
		private var nowCount:int;
		
		private const charDict:Object = {};
		
		private var _nextX:int;
		private var _nextY:int;
		
		private var _markX:int;
		private var _markY:int;
		
		private var _needUpdate:Boolean;
		
		public function TextLocator(rectSize:int, charSize:int)
		{
			this.rectSize = rectSize;
			this.charSize = charSize;
			
			rowCount = rectSize / charSize;
			maxCount = rowCount * rowCount;
		}
		
		public function get needUpdate():Boolean
		{
			return _needUpdate;
		}
		
		public function get markX():int
		{
			return _markX;
		}

		public function get markY():int
		{
			return _markY;
		}
		
		public function mark():void
		{
			_needUpdate = false;
			_markX = _nextX;
			_markY = _nextY;
		}
		
		public function canAdd(count:int):Boolean
		{
			return nowCount + count <= maxCount;
		}
		
		public function hasInfo(char:String):Boolean
		{
			return charDict.hasOwnProperty(char);
		}
		
		public function getInfo(char:String):Rectangle
		{
			return charDict[char];
		}

		public function addChar(char:String, isHalfChar:Boolean):Boolean
		{
			charDict[char] = new Rectangle(_nextX / rectSize, _nextY / rectSize, (isHalfChar ? charSize >> 1 : charSize), charSize);
			_needUpdate = true;
			if(++nowCount % rowCount == 0){
				_nextY += charSize;
				_nextX = 0;
				return true;
			}
			_nextX += charSize;
			return false;
		}
	}
}