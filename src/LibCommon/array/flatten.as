package array
{
	public function flatten(list:Array):Array
	{
		var result:Array = [];
		for each(var item:* in list){
			if(item is Array){
				append(result, arguments.callee(item));
			}else{
				result.push(item);
			}
		}
		return result;
	}
}