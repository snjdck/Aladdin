package string
{
	public function upperCaseFirst(source:String):String
	{
		if(null == source || source.length < 1){
			return source;
		}
		if(1 == source.length){
			return source.toUpperCase();
		}
		return source.charAt(0).toUpperCase() + source.slice(1);
	}
}