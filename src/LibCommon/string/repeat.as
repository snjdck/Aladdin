package string
{
	public function repeat(value:String, repeatCount:int):String
	{
		var result:String = "";
		while(repeatCount-- > 0){
			result += value;
		}
		return result;
	}
}