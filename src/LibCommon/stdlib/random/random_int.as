package stdlib.random
{
	public function random_int(a:int, b:int):int
	{
		return a + (b - a) * Math.random();
	}
}