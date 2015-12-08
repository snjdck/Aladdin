package snjdck.gpu
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	
	import string.replace;

	final public class BlendMode
	{
		static public const NORMAL		:BlendMode = new BlendMode(Context3DBlendFactor.ONE,				Context3DBlendFactor.ZERO);
		static public const ALPHAL		:BlendMode = new BlendMode(Context3DBlendFactor.SOURCE_ALPHA,		Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
		static public const ADD			:BlendMode = new BlendMode(Context3DBlendFactor.ONE,				Context3DBlendFactor.ONE);
		static public const MULTIPLY	:BlendMode = new BlendMode(Context3DBlendFactor.DESTINATION_COLOR,	Context3DBlendFactor.ZERO);
		static public const SCREEN		:BlendMode = new BlendMode(Context3DBlendFactor.ONE,				Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR);
		static public const EFFECT		:BlendMode = new BlendMode(Context3DBlendFactor.ONE,				Context3DBlendFactor.DESTINATION_ALPHA);
		static public const MASK		:BlendMode = new BlendMode(Context3DBlendFactor.DESTINATION_ALPHA,	Context3DBlendFactor.ZERO);
		static public const FILTER		:BlendMode = new BlendMode(Context3DBlendFactor.ONE,				Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
		
		private var sourceFactor:String;
		private var destinationFactor:String;
		
		public function BlendMode(source:String, dest:String)
		{
			this.sourceFactor = source;
			this.destinationFactor = dest;
		}
		
		public function apply(context3d:Context3D):void
		{
			context3d.setBlendFactors(sourceFactor, destinationFactor);
		}
		
		public function equals(other:BlendMode):Boolean
		{
			return sourceFactor == other.sourceFactor && destinationFactor == other.destinationFactor;
		}
		
		public function isOpaque():Boolean
		{
			return equals(NORMAL);
		}
		
		public function toString():String
		{
			return replace("[BlendMode(source=${0}, dest=${1})]", [sourceFactor, destinationFactor]);
		}
	}
}