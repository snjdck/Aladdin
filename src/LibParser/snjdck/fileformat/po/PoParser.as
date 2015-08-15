package snjdck.fileformat.po
{
	final public class PoParser
	{
		static private const regExp:RegExp = /"([^"]*)"/;
		static public function Parse(input:String):Object
		{
			var lineList:Array = input.split("\n");
			var result:Object = {};
			var keyMode:Boolean = false;
			var key:String;
			for each(var line:String in lineList){
				if(line.indexOf("msgid") == 0){
					keyMode = true;
				}else if(line.indexOf("msgstr") == 0){
					keyMode = false;
				}else{
					continue;
				}
				var match:Array = regExp.exec(line);
				if(keyMode){
					key = (match != null) ? match[1] : null;
				}else if(Boolean(key) && match != null){
					result[key] = match[1];
				}
			}
			return result;
		}
	}
}