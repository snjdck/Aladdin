package snjdck.g2d.particlesystem
{
	internal class DeltaValue
	{
		static public function Random(value:Number, delta:Number):Number
		{
			if(0 == delta){
				return value;
			}
			return value + delta * (Math.random() * 2 - 1);
		}
	}
}