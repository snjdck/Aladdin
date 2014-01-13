package lambda
{
	import array.append;
	import array.prepend;

	/** 偏函数 */
	public function partial(funcRef:Function, leftArgs:Array=null, rightArgs:Array=null):Function
	{
		return function():*{
			prepend(arguments, leftArgs);
			append(arguments, rightArgs);
			return apply(funcRef, arguments);
		}
	}
}