package array
{
	/**  @return list */
	public function insertArray(list:Array, index:int, items:Array):Array
	{
		if(items != null && items.length > 0)
			list.splice.apply(null, append([index, 0], items));
		return list;
	}
}