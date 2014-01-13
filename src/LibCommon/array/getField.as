package array
{
	public function getField(list:Array, field:String):Array
	{
		return list && list.map(function(item:*, index:int, array:Array):Object{
			return item[field];
		});
	}
}