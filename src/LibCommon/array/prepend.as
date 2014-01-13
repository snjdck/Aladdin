package array
{
	import lambda.apply;

	/**  @return list */
	public function prepend(list:Array, items:Array):Array
	{
		lambda.apply(list.unshift, items);
		return list;
	}
}