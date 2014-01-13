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
				var execResult:Object = FIELD_PATTERN.exec(line);
				if(execResult){
					var fieldName:String = string.trim(execResult[1]);
					currentField = resultDict[fieldName];
					if(null == currentField){
						currentField = {};
						resultDict[fieldName] = currentField;
					}
					continue;
				}
				execResult = KEY_VALUE_PATTERN.exec(line);
				if(execResult){
					var key:String = string.trim(execResult[1]);
					var value:String = string.trim(execResult[2]);
					currentField[key] = value;
				}
			}
			
			return resultDict;
		}
		
		static private const FIELD_PATTERN		:RegExp = /^\[([^\]]*)\]/;
		static private const KEY_VALUE_PATTERN	:RegExp = /([^=]+)=(.*)/;
	}
}