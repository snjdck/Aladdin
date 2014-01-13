package lambda
{
	import stdlib.reflection.getType;
	import array.prepend;

	/**
	 * func_apply([funcRef, 1, 2], [3, 4]) -> funcRef(3, 4, 1, 2)
	 */
	public function apply(funcData:*, args:Array=null):*
	{
		if(funcData is Function){
			return funcData.apply(null, args);
		}else if(funcData is Class){
			return newObject(funcData, args);
		}else if(funcData is String){
			return arguments.callee(getType(funcData), args);
		}else if(funcData is Array){
			return arguments.callee(funcData[0], prepend(funcData.slice(1), args));
		}
		return funcData;
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