package lambda
{
	import array.prepend;
	
	import flash.reflection.getType;

	/**
	 * func_apply([funcRef, 1, 2], [3, 4]) -> funcRef(3, 4, 1, 2)
	 */
	public function apply(funcData:*, args:Array=null):*
	{
		if (funcData is Function)		return funcData.apply(null, args);
		if (funcData is Class)			return newObject(funcData, args);
		if (funcData is String)			return apply(getType(funcData), args);
		if (funcData is Array == false)	return funcData;
		
		var firstItem:Object = funcData[0];
		if(firstItem is Array){
			firstItem = apply(firstItem);
		}
		if(firstItem is Function || firstItem is Class || firstItem is String){
			return apply(firstItem, prepend(funcData.slice(1), args));
		}
		return apply(firstItem[funcData[1]], prepend(funcData.slice(2), args));
	}
}
function newObject(cls:Class, args:Array):*{
	var n:int = args ? args.length : 0;
	return this["apply"+n](cls, args);
}
function apply0(cls:Class,args:Array):*{return new cls();}
function apply1(cls:Class,args:Array):*{return new cls(args[0]);}
function apply2(cls:Class,args:Array):*{return new cls(args[0],args[1]);}
function apply3(cls:Class,args:Array):*{return new cls(args[0],args[1],args[2]);}
function apply4(cls:Class,args:Array):*{return new cls(args[0],args[1],args[2],args[3]);}
function apply5(cls:Class,args:Array):*{return new cls(args[0],args[1],args[2],args[3],args[4]);}
function apply6(cls:Class,args:Array):*{return new cls(args[0],args[1],args[2],args[3],args[4],args[5]);}