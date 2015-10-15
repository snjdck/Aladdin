package snjdck.fileformat.csv
{
	public class CsvWriter
	{
		static public function WriteDict(data:Object):String
		{
			var keyDict:Object = {};
			var keyList:Array = [];
			var result:Array = [keyList];
			var keyIndex:int = 0;
			for(var colKey:String in data){
				++keyIndex;
				keyList[keyIndex] = colKey;
				var column:Object = data[colKey];
				for(var rowKey:String in column){
					var valList:Array = keyDict[rowKey];
					if(null == valList){
						valList = [rowKey];
						keyDict[rowKey] = valList;
						result.push(valList);
					}
					valList[keyIndex] = column[rowKey];
				}
			}
			return WriteList(result);
		}
		
		static public function WriteRecords(list:Array):String
		{
			if(list.length <= 0){
				return null;
			}
			var result:Array = [];
			var keyList:Array = [];
			for(var key:String in list[0]){
				keyList.push(key);
			}
			var keyCount:int = keyList.length;
			keyList.sort();
			result.push(keyList);
			for each(var item:Object in list){
				var valList:Array = [];
				for(var i:int=0; i<keyCount; ++i){
					valList[i] = item[keyList[i]];
				}
				result.push(valList);
			}
			return WriteList(result);
		}
		
		static public function WriteList(list:Array):String
		{
			var result:Array = [];
			var valList:Array = [];
			for each(var row:Array in list){
				for(var i:int=0, n:int=row.length; i<n; ++i){
					valList[i] = CastVal(row[i]);
				}
				result.push(valList.join(","));
			}
			return result.join("\r\n") + "\r\n";
		}
		
		static private function CastVal(input:String):String
		{
			if(null == input){
				return "";
			}
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