package array
{
	/**
	 * 对每个item调用handler(result, item)
	 */	
	public function reduce(list:Array, handler:Function, initVal:Object):*
	{
		var result:Object = initVal;
		for each(var item:Object in list){
			result = handler(result, item);
		}
		return result;
	}
}