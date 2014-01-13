package dict
{
	public function toArray(dict:Object):Array
	{
		var result:Array = [];
		for(var key:* in dict){
			result[result.length] = [key, dict[key]];
		}
		return result;
	}
}