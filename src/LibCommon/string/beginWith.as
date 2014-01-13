package string
{
	public function beginWith(sourceStr:String, subStr:String):Boolean
	{
		return sourceStr.indexOf(subStr) == 0;
	}
}