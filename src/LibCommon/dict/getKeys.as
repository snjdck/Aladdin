package dict
{
	public function getKeys(dict:Object):Array
	{
		var result:Array = [];
		for(var key:* in dict){
			result[result.length] = key;
		}
		return result;
	}
}