package math
{
	public function nextPowerOfTwo(val:int):int
	{
		var result:int = 1;
		while(result < val){
			result <<= 1;
		}
		return result;
	}
}