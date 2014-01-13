package lambda
{
	public function execFunc(funcRef:Function, ...args):*
	{
		return apply(funcRef, args.slice(0, funcRef.length));
	}
}