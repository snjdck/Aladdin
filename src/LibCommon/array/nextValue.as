package array
{
	public function nextValue(list:Object, index:int):*
	{
		return list[nextIndex(list, index)];
	}
}