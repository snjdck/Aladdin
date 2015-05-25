package snjdck.g2d.text
{
	import flash.geom.Rectangle;

	internal class CharInfo
	{
		public var x:int;
		public var y:int;
		
		/** 第几行  */
		public var numRow:int;
		
		public var uv:Rectangle;
		
		public function CharInfo(){}
		
		public function get uvX():int
		{
			return uv.x;
		}
		
		public function get uvY():int
		{
			return uv.y;
		}
		
		public function get width():int
		{
			return uv.width;
		}
		
		public function get height():int
		{
			return uv.height;
		}
	}
}