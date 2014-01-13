package snjdck.g3d.core
{
	import flash.display3D.Context3DBlendFactor;

	final public class BlendMode
	{
		static public const NORMAL		:BlendMode = new BlendMode(Context3DBlendFactor.ONE,				Context3DBlendFactor.ZERO);
		static public const ALPHAL		:BlendMode = new BlendMode(Context3DBlendFactor.SOURCE_ALPHA,		Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
		static public const ADD			:BlendMode = new BlendMode(Context3DBlendFactor.ONE,				Context3DBlendFactor.ONE);
		static public const MULTIPLY	:BlendMode = new BlendMode(Context3DBlendFactor.DESTINATION_COLOR,	Context3DBlendFactor.ZERO);
		static public const SCREEN		:BlendMode = new BlendMode(Context3DBlendFactor.ONE,				Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR);
		static public const EFFECT		:BlendMode = new BlendMode(Context3DBlendFactor.ONE,				Context3DBlendFactor.DESTINATION_ALPHA);
		static public const MASK		:BlendMode = new BlendMode(Context3DBlendFactor.DESTINATION_ALPHA,	Context3DBlendFactor.ZERO);
		
		public var sourceFactor:String;
		public var destinationFactor:String;
		
		public function BlendMode(source:String, dest:String)
		{
			setTo(source, dest);
		}
		
		public function equals(other:BlendMode):Boolean
		{
			return sourceFactor == other.sourceFactor && destinationFactor == other.destinationFactor;
		}
		
		private function copyFrom(other:BlendMode):void
		{
			setTo(other.sourceFactor, other.destinationFactor);
		}
		
		private function setTo(source:String, dest:String):void
		{
			this.sourceFactor = source;
			this.destinationFactor = dest;
		}
	}
}