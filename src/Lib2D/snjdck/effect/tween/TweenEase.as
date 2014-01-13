package snjdck.effect.tween
{
	final public class TweenEase
	{
		static public const Linear:Function = PowerEase(1);
		
		static public const QuadIn:Function = PowerEase(2);
		static public const QuadOut:Function = EaseOut(QuadIn);
		static public const QuadInOut:Function = EaseInOut(QuadIn);
		
		static public const CubicIn:Function = PowerEase(3);
		static public const CubicOut:Function = EaseOut(CubicIn);
		static public const CubicInOut:Function = EaseInOut(CubicIn);
		
		static public const QuartIn:Function = PowerEase(4);
		static public const QuartOut:Function = EaseOut(QuartIn);
		static public const QuartInOut:Function = EaseInOut(QuartIn);
		
		static public const QuintIn:Function = PowerEase(5);
		static public const QuintOut:Function = EaseOut(QuintIn);
		static public const QuintInOut:Function = EaseInOut(QuintIn);
		
		static public const SineOut:Function = EaseOut(SineIn);
		static public const SineInOut:Function = EaseInOut(SineIn);
		static public function SineIn(ratio:Number):Number
		{
			return 1 - Math.cos(ratio * Math.PI * 0.5);
		}
		
		static public const CircOut:Function = EaseOut(CircIn);
		static public const CircInOut:Function = EaseInOut(CircIn);
		static public function CircIn(ratio:Number):Number
		{
			return 1 - Math.sqrt(1 - ratio * ratio);
		}
		
		static public const ExpoOut:Function = EaseOut(ExpoIn);
		static public const ExpoInOut:Function = EaseInOut(ExpoIn);
		static public function ExpoIn(ratio:Number):Number
		{
			return (0 == ratio) ? 0 : Math.pow(2, 10 * (ratio - 1));
		}
		
		static public const BackOut:Function = EaseOut(BackIn);
		static public const BackInOut:Function = EaseInOut(BackIn);
		static public function BackIn(ratio:Number):Number
		{
			return ratio * ratio * (1.70158 * (ratio - 1) + ratio);
		}
		
		static public const ElasticOut:Function = EaseOut(ElasticIn);
		static public const ElasticInOut:Function = EaseInOut(ElasticIn);
		static public function ElasticIn(ratio:Number):Number
		{
			if(0 == ratio || 1 == ratio){
				return ratio;
			}
			ratio -= 1;
			return Math.pow(2, 10*ratio) * Math.sin((0.075-ratio)*Math.PI/0.15);
		}
		
		static public const BounceIn:Function = EaseOut(BounceOut);
		static public const BounceInOut:Function = EaseInOut(BounceIn);
		static public function BounceOut(ratio:Number):Number
		{
			var offset:Number = 0;
			
			if(ratio < 2/2.75){
				ratio -= 1.5/2.75;
				offset = 0.75;
			}else if(ratio < 2.5/2.75){
				ratio -= 2.25/2.75;
				offset = 0.9375;
			}else{
				ratio -= 2.625/2.75;
				offset = 0.984375;
			}
			
			return offset + 7.5625 * ratio * ratio;
		}
		
		//helper
		
		static private function PowerEase(power:int):Function
		{
			return function(ratio:Number):Number{
				return Math.pow(ratio, power);
			};
		}
		
		static private function EaseOut(easeIn:Function):Function
		{
			return function(ratio:Number):Number{
				return 1 - easeIn(1 - ratio);
			};
		}
		
		static private function EaseInOut(easeIn:Function):Function
		{
			return function(ratio:Number):Number{
				return (ratio <= 0.5) ? (0.5*easeIn(2*ratio)) : (1-arguments.callee(1-ratio));
			};
		}
	}
}