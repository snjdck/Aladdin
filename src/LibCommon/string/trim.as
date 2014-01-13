package string
{
	public function trim(str:String):String
	{
		return str.replace(/^\s+|\s+$/g, "");
	}
}