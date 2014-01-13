package array
{
	public function equals(a:Array, b:Array):Boolean
	{
		if(a.length != b.length){
			return false;
		}
		
		for(var i:int=0, n:int=a.length; i<n; i++){
			if(a[i] != b[i]){
				return false;
			}
		}
		
		return true;
	}
}