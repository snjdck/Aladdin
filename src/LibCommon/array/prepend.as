package array
{
	import lambda.apply;

	/**  @return list */
	public function prepend(list:Array, items:Array):Array
	{
		if(items != null && items.length > 0)
			lambda.apply(list.unshift, items);
		return list;
	}
}