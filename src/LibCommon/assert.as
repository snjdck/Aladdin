package
{
	import assertion.Assertion;

	public function assert(value:Object, message:String=null):void
	{
		Assertion.assertTrue(value, message);
	}
}