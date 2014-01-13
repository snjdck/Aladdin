package stdlib.common
{
	public function isType(target:Object, types:Array):Boolean
	{
		for each(var type:Class in types){
			if(target is type){
				return true;
			}
		}
		return false;
	}
}