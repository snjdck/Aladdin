package lambda
{
	public function wrap(funcRef:Function, ...args):Function
	{
		return partial(funcRef, null, args);
	}
}