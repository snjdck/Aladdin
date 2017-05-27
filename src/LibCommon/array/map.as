package array
{
	public function map(list:Object, callback:Function):*
	{
		return list.map(function(item:Object, index:int, target:Object):Object{
			return $lambda.execFunc(callback, item, index, target);
		});
	}
}