package flash.utils
{
	final public class VersionUtil
	{
		static public function isSourceVerGreatThan(source:String, compareTarget:String):Boolean
		{
			return VerToInt(source) > VerToInt(compareTarget);
		}
		
		static public function VerToInt(str:String, count:int=3):uint
		{
			var list:Array = str.split(".");
			list.length = count;
			var result:uint = 0;
			for each(var item:String in list){
				result *= 1000;
				result += parseInt(item);
			}
			return result;
		}
	}
}