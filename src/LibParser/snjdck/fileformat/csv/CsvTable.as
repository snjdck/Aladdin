package snjdck.fileformat.csv
{
	import string.has;

	internal class CsvTable
	{
		public var typeDef:Object;
		public var dataList:Array;
		
		public function CsvTable(typeDef:Object, dataList:Array)
		{
			this.typeDef = typeDef;
			this.dataList = dataList;
		}
		
		public function isComplexType(fieldName:String):Boolean
		{
			return string.has(typeDef[fieldName], ".");
		}
	}
}