package snjdck.gpu
{
	final public class GpuColor
	{
		public var alpha:Number;
		public var red:Number;
		public var green:Number;
		public var blue:Number;
		
		public function GpuColor(color:uint=0x00000000)
		{
			value = color;
		}
		
		public function get value():uint
		{
			var color:uint = 0;
			color |= (0xFF & (0xFF * alpha)) << 24;
			color |= (0xFF & (0xFF * red)) << 16;
			color |= (0xFF & (0xFF * green)) << 8;
			color |= (0xFF & (0xFF * blue));
			return color;
		}
		
		public function set value(color:uint):void
		{
			alpha = (color >>> 24) / 0xFF;
			red = ((color >>> 16) & 0xFF) / 0xFF;
			green = ((color >>> 8) & 0xFF) / 0xFF;
			blue = (color & 0xFF) / 0xFF;
		}
		
		public function get rgb():uint
		{
			var color:uint = 0;
			color |= (0xFF & (0xFF * red)) << 16;
			color |= (0xFF & (0xFF * green)) << 8;
			color |= (0xFF & (0xFF * blue));
			return color;
		}
		
		public function set rgb(color:uint):void
		{
			red = ((color >>> 16) & 0xFF) / 0xFF;
			green = ((color >>> 8) & 0xFF) / 0xFF;
			blue = (color & 0xFF) / 0xFF;
		}
		
		public function copyTo(list:Vector.<Number>, offset:int=0):void
		{
			list[offset  ] = red;
			list[offset+1] = green;
			list[offset+2] = blue;
			list[offset+3] = alpha;
		}
	}
}