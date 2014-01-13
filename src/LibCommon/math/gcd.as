package math
{
	/** 求2个数的最大公约数（greatest common divisor）*/
	public function gcd(a:int, b:int):int
	{
		var t:int;
		while(0 != (t = a % b)){
			a = b;
			b = t;
		}
		return b;
	}
}