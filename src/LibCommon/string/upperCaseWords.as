package string
{
	public function upperCaseWords(source:String):String
	{
		return source.replace(/\S+/g, function():String{
			return upperCaseFirst(arguments[0]);
		});
	}
}