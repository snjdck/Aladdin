package snjdck.g3d.asset.helper
{
	final public class GpuColor
	{
		public var alpha:Number;
		public var red:Number;
		public var green:Number;
		public var blue:Number;
		
		public function GpuColor(color:uint=0xFF000000)
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
	}
}