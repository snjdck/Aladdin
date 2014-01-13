package stdlib.random
{
	import array.has;

	public function random_generateVariableName(nChar:int, excludeList:Array=null, addResultToExcludeList:Boolean=false):String
	{
		if(nChar < 1){
			throw new ArgumentError("nChar must > 0");
		}
		
		var str:String = random_boolean() ? "_" : random_boolean() ? "$" : random_word();
		
		while(str.length < nChar){
			str += random_boolean() ? "_" : random_boolean() ? "$" : random_boolean() ? random_word() : random_digit();
		}
		
		if(excludeList){
			if(has(excludeList, str)){
				return arguments.callee(nChar, excludeList);
			}else if(addResultToExcludeList){
				excludeList.push(str);
			}
		}
		
		return str;
	}
}