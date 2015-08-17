package lambda
{
	public function callTimes(count:int, funcRef:Function, ...args):void
	{
		while(count-- > 0)
			funcRef.apply(null, args);
	}
}