package stdlib.random
{
	public function random_boolean():Boolean
	{
		return Math.random() < 0.5;
	}
}