package string
{
	public function replaceAt(source:String, fromIndex:int, toIndex:int, replacedValue:String):String
	{
		var needHead:Boolean = fromIndex > 0;
		var needTail:Boolean = toIndex < source.length;
		if(needHead && needTail){
			return source.slice(0, fromIndex) + replacedValue + source.slice(toIndex);
		}
		if(needHead){
			return source.slice(0, fromIndex) + replacedValue;
		}
		if(needTail){
			return replacedValue + source.slice(toIndex);
		}
		return replacedValue;
	}
}