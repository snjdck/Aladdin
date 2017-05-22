package array
{
	import lambda.call;

	public function removeHeadUntil(list:Object, handler:Object):void
	{
		while(list.length > 0){
			if(lambda.call(handler, list[0])){
				return;
			}
			list.removeAt(0);
		}
	}
}