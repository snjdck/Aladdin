package stdlib.random
{
	public function random_digit(nChar:int=1):String
	{
		var str:String = "";
		while(str.length < nChar){
			str += String.fromCharCode(
				random_int(48,58)
			);
		}
		return str;
	}
}