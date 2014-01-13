package stdlib.random
{
	public function random_sign():int
	{
		return random_boolean() ? 1 : -1;
	}
}