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
		return apply(funcData[0], prepend(funcData.slice(1), args));
	}
}
function newObject(cls:Class, args:Array):*{
	switch(args != null ? args.length : 0){
		case 0:return new cls();
		case 1:return new cls(args[0]);
		case 2:return new cls(args[0],args[1]);
		case 3:return new cls(args[0],args[1],args[2]);
		case 4:return new cls(args[0],args[1],args[2],args[3]);
		case 5:return new cls(args[0],args[1],args[2],args[3],args[4]);
		case 6:return new cls(args[0],args[1],args[2],args[3],args[4],args[5]);
		case 7:return new cls(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
		case 8:return new cls(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
		case 9:return new cls(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8]);
	}
	throw new Error();
}