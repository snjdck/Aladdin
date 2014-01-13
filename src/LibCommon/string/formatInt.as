package string
{
	public function formatInt(val:int, length:int=2, radix:int=10):String
	{
		var result:String = val.toString(radix).toUpperCase();
		while(result.length < length){//如果输入的字符串长度小于指定的长度,则左边填充0
			result = "0" + result;
		}
		return result;
	}
}