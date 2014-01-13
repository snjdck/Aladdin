package array
{
	/** [1,2,3,4] and [3,4,5,6] = [3,4] */
	public function and(a:Array, b:Array):Array
	{
		return sub(a, sub(a, b));
	}
}