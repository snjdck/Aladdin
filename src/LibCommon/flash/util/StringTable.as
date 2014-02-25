package flash.util
{
	import string.replace;
	import string.trim;

	/**
	 * 1 = 邵凯
	 * <br/>
	 * 2 = 我是${1},你是${name}?
	 */
	final public class StringTable
	{
		static private const Delimiter:String = "\n";
		static private const Pattern:RegExp = /(\w+)\s*=(.*)/;
		
		private const strDict:Object = {};
		
		public function StringTable()
		{
		}
		
		public function importData(data:String):void
		{
			for each(var line:String in data.split(Delimiter)){
				var result:Object = Pattern.exec(line);
				if (null == result) continue;
				var key:String = result[1];
				var value:String = trim(result[2]);
				strDict[key] = replace(value, strDict);
			}
		}
		
		public function getString(id:Object, args:Object=null):String
		{
			return replace(strDict[id], args);
		}
	}
}