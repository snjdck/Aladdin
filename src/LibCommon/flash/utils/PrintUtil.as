package flash.utils
{
	final public class PrintUtil
	{
		static public function getMinTabCount(list:Array):int
		{
			var result:int = 0;
			for each(var item:String in list){
				var max:int = Math.ceil(item.length / 8);
				var min:int = item.length >> 3;
				if(min == max){
					++max;
				}
				if(result < max){
					result = max;
				}
			}
			return result;
		}
		
		static public function prettyTrace(a:String, b:String, tabCount:int):void
		{
			tabCount -= a.length >> 3;
			var tabStr:String = "";
			while(tabStr.length < tabCount){
				tabStr += "\t";
			}
			trace(a+tabStr+b);
		}
	}
}