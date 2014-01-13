package snjdck.fileformat.csv
{
	import array.getItem;
	import array.getItemList;
	import array.mapKey;
	
	import string.execRegExp;

	final public class CsvParser
	{
		/**
		 * 第一行:字段名称
		 * 第二行:字段描述
		 * 第三行:数据类型 int, boolean, number, ref=table.key, link=(field@)?table.key
		 * 
		 * @param context {key=tableName, value=csvText}
		 */
		static public function Parse(context:Object):Object
		{
			var tableContext:Object = {};
			var tableName:String;
			
			for(tableName in context){
				var indexList:Array = csv_to_list(context[tableName]);
				for(var i:int=2, n:int=indexList.length; i<n; i++){
					indexList[i] = mapKey(indexList[i], indexList[0]);
				}
				tableContext[tableName] = new CsvTable(indexList.splice(0, 3)[2], indexList);
			}
			
			WalkRecord(tableContext, ParseType, null);
			WalkRecord(tableContext, ParseRef, A);
			WalkRecord(tableContext, ParseRef, B);
			
			for(tableName in tableContext){//删除类型信息
				var table:CsvTable = tableContext[tableName];
				tableContext[tableName] = table.dataList;
			}
			
			return tableContext;
		}
		
		static private function WalkRecord(context:Object, callback:Function, handler:Function):void
		{
			for each(var table:CsvTable in context){//每张表
				for(var key:String in table.typeDef){//表中的每个字段
					var type:String = table.typeDef[key];//字段类型信息
					for each(var record:Object in table.dataList){//表中的每条记录
						callback(record, key, type, context, handler);
					}
				}
			}
		}
		
		static private function ParseRef(record:Object, key:String, type:String, context:Object, handler:Function):void
		{
			var test:Array = execRegExp(/(?:(\w+)@)?(\w+)\.(\w+)/, type);
			if(test != null){
				handler(record, key, context[test[2]], test[3]);
			}
		}
		
		static private function A(record:Object, key:String, table:CsvTable, fieldName:String):void
		{
			if(!table.isComplexType(fieldName)){
				record[key] = getItem(table.dataList, fieldName, record[key]);
			}
		}
		
		static private function B(record:Object, key:String, table:CsvTable, fieldName:String):void
		{
			if(table.isComplexType(fieldName)){
				record[key] = getItemList(table.dataList, fieldName, record);
			}
		}
		
		static private function ParseType(record:Object, key:String, type:String, context:Object, handler:Function):void
		{
			switch(type){
				case "int":
					record[key] = int(record[key]);
					break;
				case "boolean":
					record[key] = (0 != int(record[key]));
					break;
				case "number":
					record[key] = parseFloat(record[key]);
					break;
			}
		}
	}
}