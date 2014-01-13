package string
{
	public function trimLeft(str:String):String
	{
		return str.replace(/^\s+/, "");
	}
}