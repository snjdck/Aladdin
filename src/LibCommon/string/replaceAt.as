package string
{
	public function replaceAt(source:String, fromIndex:int, toIndex:int, replacedValue:String):String
	{
		return source.slice(0, fromIndex) + replacedValue + source.slice(toIndex);
	}
}