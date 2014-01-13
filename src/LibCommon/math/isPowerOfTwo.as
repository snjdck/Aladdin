package math
{
	public function isPowerOfTwo(x:int):Boolean
	{
		return (x > 0) && ((x & (x-1)) == 0);
	}
}