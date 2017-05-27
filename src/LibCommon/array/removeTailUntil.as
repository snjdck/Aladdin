package array
{
	public function removeTailUntil(list:Object, handler:Object):void
	{
		for(var i:int=list.length-1; i>=0; --i){
			if($lambda.call(handler, list[i])){
				return;
			}
			list.removeAt(i);
		}
	}
}