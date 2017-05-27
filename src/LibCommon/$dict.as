package{
	public const $dict:Dict = new Dict();
}

class Dict
{
	public function addKey(dict:Object, key:Object):void
	{
		dict[key] = null;
	}
	
	public function clear(dict:Object):void
	{
		for(var key:* in dict){
			delete dict[key];
		}
	}
	
	public function compare(a:Object, b:Object, handler:Object):void
	{
		var key:String;
		for(key in a){
			if(!(key in b)){
				$lambda.call(handler, -1, key);
			}else if(a[key] != b[key]){
				$lambda.call(handler, 0, key);
			}
		}
		for(key in b){
			if(!(key in a)){
				$lambda.call(handler, 1, key);
			}
		}
	}
	
	public function deleteKey(dict:Object, key:Object):*
	{
		var val:Object = dict[key];
		delete dict[key];
		return val;
	}
	
	public function getKeys(dict:Object):Array
	{
		var result:Array = [];
		for(var key:* in dict){
			result[result.length] = key;
		}
		return result;
	}
	
	public function getNumKeys(dict:Object):int
	{
		var result:int = 0;
		for(var key:* in dict){
			++result;
		}
		return result;
	}
	
	public function getValues(dict:Object):Array
	{
		var result:Array = [];
		for each(var value:* in dict){
			result[result.length] = value;
		}
		return result;
	}
	
	public function hasKey(dict:Object, key:Object):Boolean
	{
		return (dict != null) && (key in dict);
	}
	
	public function hasValue(dict:Object, val:Object):Boolean
	{
		for each(var value:* in dict){
			if(value == val){
				return true;
			}
		}
		return false;
	}
	
	public function isEmpty(dict:Object):Boolean
	{
		for(var key:* in dict){
			return false;
		}
		return true;
	}
	
	public function toArray(dict:Object):Array
	{
		var result:Array = [];
		for(var key:* in dict){
			result[result.length] = [key, dict[key]];
		}
		return result;
	}
}