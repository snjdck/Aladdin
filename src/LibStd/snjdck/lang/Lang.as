package snjdck.lang
{
	import string.replace;
	import string.trim;

	/**
	 * 1 = 邵凯
	 * <br/>
	 * 2 = 我是${1},你是${name}?
	 */	
	final public class Lang
	{
		static private const Delimiter:String = "\n";
		static private const Pattern:RegExp = /(\w+)\s*=(.*)/;
		
		static private const Dict:Object = {};
		
		static public function InitData(data:String):void
		{
			for each(var line:String in data.split(Delimiter)){
				var result:Object = Pattern.exec(line);
				if(result){
					Dict[result[1]] = replace(trim(result[2]), Dict);
				}
			}
		}
		
		static public function GetString(id:Object, args:Object=null):String
		{
			return string.replace(Dict[id], args);
		}
	}
}