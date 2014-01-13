package dict
{
	public function getValues(dict:Object):Array
	{
		var result:Array = [];
		for each(var value:* in dict){
			result[result.length] = value;
		}
		return result;
	}
}