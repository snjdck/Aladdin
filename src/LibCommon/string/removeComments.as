package string
{
	public function removeComments(str:String):String
	{
		return str.replace(/\s*#.*(?=\r\n|$)/g, "");
	}
}