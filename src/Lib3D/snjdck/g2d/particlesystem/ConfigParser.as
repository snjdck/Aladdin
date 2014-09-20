package snjdck.g2d.particlesystem
{
	import flash.display3D.Context3DBlendFactor;
	
	import snjdck.gpu.GpuColor;

	internal class ConfigParser
	{
		private var config:XML;
		
		public function ConfigParser(config:XML)
		{
			this.config = config;
		}
		
		public function getInt(key:String):int
		{
			return parseInt(config[key].@value);
		}
		
		public function getNumber(key:String, prop:String="value"):Number
		{
			return parseFloat(config[key].@[prop]);
		}
		
		public function getColor(key:String, result:GpuColor):void
		{
			var node:XMLList = config[key];
			result.red = parseFloat(node.@red);
			result.green = parseFloat(node.@green);
			result.blue = parseFloat(node.@blue);
			result.alpha = parseFloat(node.@alpha);
		}
		
		public function getBlendFactor(key:String):String
		{
			var value:int = getInt(key);
			switch (value)
			{
				case 0:     return Context3DBlendFactor.ZERO;
				case 1:     return Context3DBlendFactor.ONE;
				case 0x300: return Context3DBlendFactor.SOURCE_COLOR;
				case 0x301: return Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR;
				case 0x302: return Context3DBlendFactor.SOURCE_ALPHA;
				case 0x303: return Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
				case 0x304: return Context3DBlendFactor.DESTINATION_ALPHA;
				case 0x305: return Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA;
				case 0x306: return Context3DBlendFactor.DESTINATION_COLOR;
				case 0x307: return Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR;
			}
			throw new ArgumentError("unsupported blending function: " + value);
		}
	}
}