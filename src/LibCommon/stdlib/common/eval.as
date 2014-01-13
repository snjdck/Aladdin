package stdlib.common
{
	import lambda.apply;
	import string.execRegExp;
	import string.has;

	public function eval(context:Object, expression:String):*
	{
		expression = expression.replace(/\s+/g, "");
		if(has(expression, "(")){//is a function call
			var result:Array = execRegExp(/([^(]+)\(([^)]*)\)/, expression);
			return apply(getProp(context, result[1]), calcArgs(result[2], context));
		}
		//get a prop value
		return getProp(context, expression);
	}
}