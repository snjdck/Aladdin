package stdlib.random
{
	public function random_createGen(seed:uint):Function
	{
		return function():Number
		{
			seed ^= seed << 21;
			seed ^= seed >>> 35;
			seed ^= seed << 4;
			return seed / uint.MAX_VALUE;
		};
	}
}