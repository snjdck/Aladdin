package math
{
	public function factorial(n:uint):uint
	{
		var result:uint = 1;
		while(n > 1){
			result *= n--;
		}
		return result;
	}
}