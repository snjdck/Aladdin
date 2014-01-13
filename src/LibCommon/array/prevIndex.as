package array
{
	public function prevIndex(list:Object, index:int):int
	{
		return (index > 0) ? (index-1) : (list.length-1);
	}
}