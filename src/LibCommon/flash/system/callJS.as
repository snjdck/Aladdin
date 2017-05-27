package flash.system
{
	import flash.external.ExternalInterface;
	
	import array.append;

	public function callJS(funcName:String, args:Array):*
	{
		if(false == ExternalInterface.available){
			return;
		}
		return ExternalInterface.call.apply(null, append([funcName], args));
	}
}