package stdlib.common
{
	public function getProp(target:Object, prop:String):*
	{
		for each(var key:String in prop.split(".")){
			if(target){
				target = target[key];
			}else{
				return null;
			}
		}
		return target;
	}
}