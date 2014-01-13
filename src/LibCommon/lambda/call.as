package lambda
{
	public function call(funcData:*, ...args):*
	{
		return apply(funcData, args);
	}
}