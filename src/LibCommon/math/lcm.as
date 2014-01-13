package math
{
	/** 求2个数的最小公倍数（least common multiple）*/
	public function lcm(a:int, b:int):int
	{
		return a * b / gcd(a, b);
	}
}