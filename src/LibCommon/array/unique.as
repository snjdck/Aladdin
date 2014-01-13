package array
{
	public function unique(list:Array):Array
	{
		var result:Array = [];
		return sub(list, result, result);
	}
}