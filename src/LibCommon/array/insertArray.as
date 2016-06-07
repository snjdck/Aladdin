package array
{
	import lambda.apply;

	/**  @return list */
	public function insertArray(list:Array, index:int, items:Array):Array
	{
		if(items != null && items.length > 0)
			lambda.apply(list.splice, append([index, 0], items));
		return list;
	}
}