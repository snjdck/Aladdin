package system
{
	import flash.external.ExternalInterface;
	
	import array.append;
	
	import lambda.apply;

	public function callJS(funcName:String, args:Array):*
	{
		if(false == ExternalInterface.available){
			return;
		}
		return lambda.apply(ExternalInterface.call, append([funcName], args));
	}
}