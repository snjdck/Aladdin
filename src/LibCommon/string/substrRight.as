package string
{
	public function substrRight(source:String, count:int):String
	{
		if(count >= source.length){
			return source;
		}
		return source.substr(source.length-count);
	}
}