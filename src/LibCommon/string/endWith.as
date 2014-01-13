package string
{
	public function endWith(sourceStr:String, subStr:String):Boolean
	{
		var countDiff:int = sourceStr.length - subStr.length;
		return countDiff >= 0 && sourceStr.lastIndexOf(subStr) == countDiff;
	}
}