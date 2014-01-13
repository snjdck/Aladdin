package snjdck.fileformat.csv
{
	public function csv_to_list(source:String):Array
	{
		const result:Array = [];
		
		var line:Array = [];
		var field:String = "";
		
		var isReadingString:Boolean = false;
		
		for(var i:int=0, n:int=source.length; i<n; i++)
		{
			var char:String = source.charAt(i);
			
			if(isReadingString){
				if(char != '"'){
					field += char;
				}else if(i < n-1 && source.charAt(i+1) == '"'){
					field += char;
					++i;
				}else{
					isReadingString = false;
				}
				continue;
			}
			
			switch(char)
			{
				case ',':
				case '\r':
					line.push(field);
					field = "";
					break;
				case '"':
					isReadingString = true;
					break;
				case '\n':
					result.push(line);
					line = [];
					break;
				default:
					field += char;
			}
		}
		
		return result;
	}
}