package snjdck.fileformat.po
{
	import string.trim;

	final public class PoParser
	{
		static private const regExp:RegExp = /^msg(?:id|str)\s+"(.*)"$/;
		static public function Parse(input:String):Object
		{
			var lineList:Array = input.split("\n");
			var result:Object = {};
			var keyMode:Boolean = false;
			var key:String;
			
			for each(var line:String in lineList){
				line = trim(line);
				if(line.indexOf("msgid") == 0){
					keyMode = true;
				}else if(line.indexOf("msgstr") == 0){
					keyMode = false;
				}else{
					if(line.length > 0 && line.indexOf("#") > 0){
						trace(line);
					}
					continue;
				}
				var match:Array = regExp.exec(line);
				var value:String = (match != null) ? match[1] : null;
				if(keyMode){
					key = value;
				}else if(Boolean(key) && Boolean(value)){
					result[key] = value;
				}else{
					trace(line);
				}
			}
			return result;
		}
	}
}