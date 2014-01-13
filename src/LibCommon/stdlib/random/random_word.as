package stdlib.random
{
	public function random_word(nChar:int=1):String
	{
		var str:String = "";
		while(str.length < nChar){
			str += String.fromCharCode(
				random_boolean() ? random_int(65,91) : random_int(97,123)
			);
		}
		return str;
	}
}