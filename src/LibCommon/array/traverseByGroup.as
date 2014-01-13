package array
{
	import flash.utils.Dictionary;

	public function traverseByGroup(list:Object, keys:Array, callbacks:Array, index:int=0):Object
	{
		var dict:Object = groupByKey(list, keys[index]);
		var key:* = null, value:* = null;
		
		const flag:Boolean = index + 1 < keys.length;
		for(key in dict){
			callbacks[index](key);
			if(flag){
				dict[key] = traverseByGroup(dict[key], keys, callbacks, index+1);
			}else{
				for each(value in dict[key]){
					callbacks[index+1](value);
				}
			}
		}
		
		return dict;
	}
}

import flash.utils.Dictionary;

import dict.hasKey;

function groupByKey(list:Object, key:String):Object
{
	var dict:Object = new Dictionary();
	
	for each(var item:Object in list){
		var value:Object = item[key];
		if(hasKey(dict, value)){
			(dict[value] as Array).push(item);
		}else{
			dict[value] = [item];
		}
	}
	
	return dict;
}