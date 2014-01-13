package dict
{
	public function getNumKeys(dict:Object):int
	{
		var result:int = 0;
		for(var key:* in dict){
			++result;
		}
		return result;
	}
}