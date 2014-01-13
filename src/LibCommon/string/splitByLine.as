package string
{
	public function splitByLine(str:String):Array
	{
		return str.split(/\s*\r\n\s*/);
	}
}