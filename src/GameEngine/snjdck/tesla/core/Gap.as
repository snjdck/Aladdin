package snjdck.tesla.core
{
	import flash.geom.Rectangle;

	/**
	 * css
	 * 上,右,下,左
	 * 上,右左,下
	 * 上下,右左
	 */
	public class Gap
	{
		public var top		:Number;
		public var right	:Number;
		public var bottom	:Number;
		public var left		:Number;
		
		public function Gap(top:Number=0, right:Number=0, bottom:Number=0, left:Number=0)
		{
			this.top = top;
			this.right = right;
			this.bottom = bottom;
			this.left = left;
		}
		
		public function clone():Gap
		{
			return new Gap(top, right, bottom, left);
		}
		
		public function inflate(value:Number):void
		{
			top		+= value;
			right	+= value;
			bottom	+= value;
			left	+= value;
		}
		
		public function getRect(source:Rectangle):Rectangle
		{
			var result:Rectangle = source.clone();
			
			result.left		-= left;
			result.top		-= top;
			result.right	+= right;
			result.bottom	+= bottom;
			
			return result;
		}
	}
}