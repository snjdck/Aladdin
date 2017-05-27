package{
	public const $lambda:Lambda = new Lambda();
}

import flash.system.ApplicationDomain;

import array.append;
import array.prepend;

class Lambda
{
	/**
	 * func_apply([funcRef, 1, 2], [3, 4]) -> funcRef(3, 4, 1, 2)
	 */
	public function apply(funcData:*, args:Array=null):*
	{
		for(;;){
			if (funcData is String)
				funcData =  ApplicationDomain.currentDomain.getDefinition(funcData);
			if (funcData is Function)		return funcData.apply(null, args);
			if (funcData is Class)			return newObject(funcData, args);
			if (funcData is Array == false)	return funcData;
			args = prepend(funcData.slice(1), args);
			funcData = funcData[0];
		}
	}
	
	public function call(funcData:*, ...args):*
	{
		return apply(funcData, args);
	}
	
	public function callTimes(count:int, funcRef:Function, ...args):void
	{
		while(count-- > 0)
			funcRef.apply(null, args);
	}
	
	/** 函数组合 */
	public function compose(...args):Function
	{
		var firstFuncRef:Object = args.pop();
		args.reverse();
		
		return function():*{
			var result:Object = apply(firstFuncRef, arguments);
			for each(var funcRef:Function in args){
				result = call(funcRef, result);
			}
			return result;
		}
	}
	
	public function execFunc(funcRef:Function, ...args):*
	{
		return apply(funcRef, args.slice(0, funcRef.length));
	}
	
	/** 偏函数 */
	public function partial(funcRef:Function, leftArgs:Array=null, rightArgs:Array=null):Function
	{
		return function():*{
			prepend(arguments, leftArgs);
			append(arguments, rightArgs);
			return funcRef.apply(null, arguments);
		}
	}
	
	public function wrap(funcRef:Function, ...args):Function
	{
		return partial(funcRef, null, args);
	}
	
	private function newObject(cls:Class, args:Array):*
	{
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
}