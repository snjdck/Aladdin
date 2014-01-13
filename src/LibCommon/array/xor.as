package array
{
	/** [1,2,3,4] xor [3,4,5,6] = [1,2,5,6] */
	public function xor(a:Array, b:Array):Array
	{
		return append(sub(a, b), sub(b, a));
	}
}