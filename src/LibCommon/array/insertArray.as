package array
{
	import lambda.apply;

	/**  @return list */
	public function insertArray(list:Array, index:int, items:Array):Array
	{
		lambda.apply(list.splice, append([index, 0], items));
		return list;
	}
}