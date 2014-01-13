package array
{
	public function prevValue(list:Object, index:int):*
	{
		return list[prevIndex(list, index)];
	}
}