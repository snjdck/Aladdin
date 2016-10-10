package string
{
	import dict.hasKey;

	/**
	 * my ${a} is ${b}
	 * <br/>
	 * my ${0} is ${1}, ${2} is my brother!
	 */
	public function replace2(source:String, args:Object):String
	{
		return source.replace(/\$\{\s*([^{}\s]+)\s*\}/g, function():String{
			var key:String = arguments[1];
			var index:int = key.indexOf("|");
			if(index >= 0){
				var subArgs:Array = key.slice(index+1).split(",");
				key = key.slice(0, index);
			}
			if(!hasKey(args, key)){
				return arguments[0];
			}
			if(subArgs != null){
				return replace(args[key], subArgs);
			}
			return args[key];
		});
	}
}