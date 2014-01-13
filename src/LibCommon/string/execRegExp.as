package string
{
	public function execRegExp(pattern:RegExp, str:String):Array
	{
		return pattern.exec(str);
	}
}