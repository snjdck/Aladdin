package array
{
	/**
	 * mapKey([10, 20, 30], ["a", "b", "c"]) == {"a":10, "b":20, "c":30}
	 */
	public function mapKey(list:Array, keyList:Array):Object
	{
		var result:Object = {};
		
		for(var i:int, n:int=list.length; i<n; i++){
			result[keyList[i]] = list[i];
		}
		
		return result;
	}
}