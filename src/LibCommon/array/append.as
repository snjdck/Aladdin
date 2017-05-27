package array
{
	/**  @return list */
	public function append(list:Array, items:Array):Array
	{
		if(items != null && items.length > 0)
			list.push.apply(null, items);
		return list;
	}
}