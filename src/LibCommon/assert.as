package
{
	import flash.debugger.enterDebugger;

	[Inline]
	public function assert(value:Object, message:String=null):void
	{
		if(Boolean(value) == false){
			throw new VerifyError(message);
			enterDebugger();
		}
	}
}