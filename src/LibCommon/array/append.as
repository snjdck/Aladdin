package array
{
	import lambda.apply;

	/**  @return list */
	public function append(list:Array, items:Array):Array
	{
		if(items != null && items.length > 0)
			lambda.apply(list.push, items);
		return list;
	}
}