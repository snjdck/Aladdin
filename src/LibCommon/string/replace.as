package string
{
	import dict.hasKey;

	/**
	 * my ${a} is ${b}
	 * <br/>
	 * my ${0} is ${1}, ${2} is my brother!
	 */
	public function replace(source:String, args:Object):String
	{
		return source.replace(/\$\{\s*([.\w]+)\s*\}/g, function():String{
			var key:String = arguments[1];
			if(hasKey(args, key)){
				return args[key];
			}
			return arguments[0];
		});
	}
}