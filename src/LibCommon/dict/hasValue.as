package dict
{
	public function hasValue(dict:Object, val:Object):Boolean
	{
		for each(var value:* in dict){
			if(value == val){
				return true;
			}
		}
		return false;
	}
}