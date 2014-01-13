package math
{
	public function permutation(m:uint, n:uint):uint
	{
		if(m < n){
			return 0;
		}
		var result:uint = 1;
		while(n-- > 0){
			result *= m--;
		}
		return result;
	}
}