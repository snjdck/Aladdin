package assertion
{
	import flash.debugger.enterDebugger;

	final public class Assertion
	{
		static public function assertTrue(value:Object, message:String=null):void
		{
			if(Boolean(value) == false){
				throw new VerifyError(message);
				enterDebugger();
			}
		}
	}
}