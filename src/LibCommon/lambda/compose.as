package lambda
{
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
}