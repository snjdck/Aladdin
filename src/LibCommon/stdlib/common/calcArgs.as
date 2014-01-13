package stdlib.common
{
	internal function calcArgs(argsStr:String, context:Object):Array
	{
		if(null == argsStr || 0 == argsStr.length){
			return null;
		}
		return argsStr.split(",").map(function(argStr:String, index:int, array:Array):Object{
			switch(argStr){
				case "true":	return true;
				case "false":	return false;
				case "this":	return context;
				default:		return Number(argStr);
			}
		});
	}
}