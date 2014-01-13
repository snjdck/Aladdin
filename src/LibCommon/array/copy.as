package array
{
	/** @return to */
	public function copy(from:Object, to:Object, count:int, fromOffset:int=0, toOffset:int=0):*
	{
		for(var i:int=0; i<count; i++){
			to[toOffset+i] = from[fromOffset+i];
		}
		return to;
	}
}