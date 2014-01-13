package snjdck.game.common.utils.ds
{
	//这个类也可以用一维数组来实现
	public class IntMap
	{
		private const _data:Array = [];
		private var _width:int;
		private var _height:int;
		
		public function IntMap(width:int, height:int)
		{
			this._width = width;
			this._height = height;
			
			reset();
		}
		
		public function get width():int		{ return this._width; }
		public function get height():int	{ return this._height; }
		
		public function reset():void
		{
			var i:int = 0;
			var n:int = width * height;
			
			while(i<n) _data[i++] = 0;
		}
		
		public function getValueAt(x:int, y:int):int
		{
			return isIndexInRange(x, y) ? _data[ getIndex(x, y) ] : 0;
		}
		
		public function setValueAt(x:int, y:int, value:int):void
		{
			if( isIndexInRange(x, y) ) _data[ getIndex(x, y) ] = value;
		}
		
		private function isIndexInRange(x:int, y:int):Boolean
		{
			return (x < width && y < height && x >= 0 && y >=0);
		}
		
		private function getIndex(x:int, y:int):int
		{
			return y * width + x;
		}
		//over
	}
}