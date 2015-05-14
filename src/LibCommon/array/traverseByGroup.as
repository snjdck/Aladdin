package array
{
	import flash.utils.Dictionary;

	public function traverseByGroup(list:Object, keys:Array, callbacks:Array, index:int=0):Object
	{
		var hashMap:Object = groupByKey(list, keys[index]);
		var key:* = null, value:* = null;
		
		const flag:Boolean = index + 1 < keys.length;
		for(key in hashMap){
			callbacks[index](key);
			if(flag){
				hashMap[key] = traverseByGroup(hashMap[key], keys, callbacks, index+1);
			}else{
				for each(value in hashMap[key]){
					callbacks[index+1](value);
				}
			}
		}
		
		return hashMap;
	}
}

import flash.utils.Dictionary;

import dict.hasKey;

function groupByKey(list:Object, key:String):Object
{
	var hashMap:Object = new Dictionary();
	
	for each(var item:Object in list){
		var value:Object = item[key];
		if(hasKey(hashMap, value)){
			(hashMap[value] as Array).push(item);
		}else{
			hashMap[value] = [item];
		}
	}
	
	return hashMap;
}