package array
{
	public function insert(list:Object, index:int, item:Object):void
	{
		list.splice(index, 0, item);
	}
}