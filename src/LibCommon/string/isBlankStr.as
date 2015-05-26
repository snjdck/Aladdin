package string
{
	public function isBlankStr(str:String):Boolean
	{
		for(var i:int=0, n:int=str.length; i<n; ++i){
			if(!isBlankChar(str.charAt(i))){
				return false;
			}
		}
		return true;
	}
}