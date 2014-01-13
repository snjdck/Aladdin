package string
{
	public function removeSpace(str:String):String
	{
		return str.replace(/[\x20\t]+/g, "");
	}
}