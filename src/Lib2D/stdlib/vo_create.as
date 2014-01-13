package stdlib
{
	import lambda.apply;

	public function vo_create(voData:Object, wrapper:Object):*
	{
		var vo:Object = apply(wrapper);
		for(var key:Object in voData){
			setProp(vo, key, voData[key]);
		}
		return vo;
	}
}

import stdlib.vo_create;

function setProp(target:Object, key:Object, value:Object):void
{
	try{
		target[key] = value;
	}catch(error:Error){
		if(1034 == error.errorID){
			var regExp:RegExp = (value is Array) ? (/(__AS3__\.vec\.Vector\.<([$.\w]+)>)/) : (/\s([$.\w]+).$/);
			var result:Array = regExp.exec(error.message);
			if(null != result){
				setProp(target, key, vo_create(value, result[1]));
				return;
			}
		}
		throw error;
	}
}