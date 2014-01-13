package math
{
	public function combination(m:uint, n:uint):uint
	{
		return permutation(m, n) / factorial(n);
	}
}