package stdlib.random
{
	public function random_getValueFromArray(list:Array, remove:Boolean=false):*
	{
		var index:int = random_int(0, list.length);
		return remove ? list.splice(index, 1)[0] : list[index];
	}
}