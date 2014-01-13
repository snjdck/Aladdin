package array
{
	public function nextIndex(list:Object, index:int):int
	{
		return (index < list.length-1) ? (index+1) : 0;
	}
}