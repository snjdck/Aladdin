package snjdck.fileformat.csv
{
	public class CsvWriter
	{
		static public function WriteCsv(list:Array):String
		{
			if(list.length <= 0){
				return null;
			}
			var result:Array = [];
			var keyList:Array = [];
			var valList:Array = [];
			for(var key:String in list[0]){
				keyList.push(key);
			}
			var keyCount:int = keyList.length;
			keyList.sort();
			result.push(keyList.join(","));
			for each(var item:Object in list){
				for(var i:int=0; i<keyCount; ++i){
					valList[i] = CastVal(item[keyList[i]]);
				}
				result.push(valList.join(","));
			}
			return result.join("\r\n") + "\r\n";
		}
		
		static private function CastVal(input:String):String
		{
			if(input.indexOf('"') >= 0){
				return AddQuotes(input.replace(/"/g, '""'));
			}
			if(input.indexOf(",") >= 0){
				return AddQuotes(input);
			}
			return input;
		}
		
		static private function AddQuotes(input:String):String
		{
			return '"' + input + '"';
		}
	}
}