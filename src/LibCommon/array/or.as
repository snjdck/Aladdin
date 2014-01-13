package array
{
	/** [1,2,3,4] or [3,4,5,6] = [1,2,3,4,5,6] */
	public function or(a:Array, b:Array):Array
	{
		return append(sub(a, b), b);
	}
}