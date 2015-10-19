package string
{
	import lambda.call;

	public function replaceAll(input:String, key:String, handler:Object):String
	{
		var result:String = input;
		var index:int = 0;
		var count:int = 0;
		for(;;){
			index = result.indexOf(key, index);
			if(index < 0){
				break;
			}
			var value:String = call(handler, key, ++count);
			result = result.replace(key, value);
			index += value.length;
		}
		return result;
	}
}