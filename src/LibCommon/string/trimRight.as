package string
{
	public function trimRight(str:String):String
	{
		return str.replace(/\s+$/, "");
	}
}