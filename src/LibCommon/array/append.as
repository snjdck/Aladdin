package array
{
	import lambda.apply;

	/**  @return list */
	public function append(list:Array, items:Array):Array
	{
		lambda.apply(list.push, items);
		return list;
	}
}