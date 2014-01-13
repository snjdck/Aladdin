package stdlib.typecast
{
	public function vector_to_array(vector:Object):Array
	{
		var result:Array = [];
		for each(var item:Object in vector){
			result[result.length] = item;
		}
		return result;
	}
}