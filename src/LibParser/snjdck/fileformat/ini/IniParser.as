package snjdck.fileformat.ini
{
	import string.trim;

	final public class IniParser
	{
		static public function Parse(source:String):Object
		{
			const resultDict:Object = {};
			var currentField:Object;
			
			for each(var line:String in source.split("\r\n"))
			{
				var execResult:Object = PATTERN_FIELD.exec(line);
				if(execResult){
					var fieldName:String = string.trim(execResult[1]);
					currentField = resultDict[fieldName];
					if(null == currentField){
						currentField = {};
						resultDict[fieldName] = currentField;
					}
					continue;
				}
				execResult = PATTERN_KEY_VALUE.exec(line);
				if(execResult){
					var key:String = string.trim(execResult[1]);
					var value:String = string.trim(execResult[2]);
					currentField[key] = value;
				}
			}
			
			return resultDict;
		}
		
		static private const PATTERN_FIELD		:RegExp = /^\[([^\]]*)\]/;
		static private const PATTERN_KEY_VALUE	:RegExp = /([^=]+)=(.*)/;
	}
}