package array
{
	/**  @return list */
	public function prepend(list:Array, items:Array):Array
	{
		if(items != null && items.length > 0)
			list.unshift.apply(null, items);
		return list;
	}
}