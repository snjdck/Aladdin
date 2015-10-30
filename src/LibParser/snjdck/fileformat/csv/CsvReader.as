package snjdck.fileformat.csv
{
	public class CsvReader
	{
		static public function ReadDict(list:Array):Object
		{
			var result:Object = {};
			for(var i:int=1, n:int=list.length; i<n; ++i){
				var line:Array = list[i];
				var key:String = line[0];
				for(var j:int=1, m:int=line.length; j<m; ++j){
					var column:String = list[0][j];
					if(null == result[column]){
						result[column] = {};
					}
					var value:String = line[j];
					if(Boolean(value)){
						result[column][key] = value;
					}
				}
			}
			return result;
		}
	}
}