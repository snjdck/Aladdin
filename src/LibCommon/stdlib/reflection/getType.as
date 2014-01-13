package stdlib.reflection
{
	import flash.system.ApplicationDomain;

	public function getType(target:*, domain:ApplicationDomain=null):*
	{
		if(target is Function || target is Class){
			return target;
		}
		if(!(target is String)){
			return target["constructor"];
		}
		if(null == domain){
			domain = ApplicationDomain.currentDomain;
		}
		if(domain.hasDefinition(target)){
			return domain.getDefinition(target);
		}
		return null;
	}
}