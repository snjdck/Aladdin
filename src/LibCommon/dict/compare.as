package dict
{
	import lambda.call;

	public function compare(a:Object, b:Object, handler:Object):void
	{
		var key:String;
		for(key in a){
			if(!(key in b)){
				call(handler, -1, key);
			}else if(a[key] != b[key]){
				call(handler, 0, key);
			}
		}
		for(key in b){
			if(!(key in a)){
				call(handler, 1, key);
			}
		}
	}
}