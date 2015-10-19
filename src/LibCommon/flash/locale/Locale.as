package flash.locale
{
	import flash.utils.Dictionary;
	
	import string.replaceAll;

	public class Locale
	{
		private var defineDict:Object;
		private var patternDict:Object;
		private var cacheDict:Object;
		
		public function Locale()
		{
			defineDict = {};
			patternDict = new Dictionary();
			cacheDict = {};
		}
		
		public function addDefine(key:String, value:String):void
		{
			defineDict[key] = value;
		}
		
		public function addPattern(pattern:String, text:String):void
		{
			patternDict[new RegExp(parseInput(pattern))] = replaceAll(text, "\\0", parseOutput);
		}
		
		public function translate(input:String):String
		{
			var output:String = cacheDict[input];
			if(output != null){
				return output;
			}
			for(var pattern:RegExp in patternDict){
				var result:Array = pattern.exec(input);
				if(result != null){
					output = input.replace(pattern, patternDict[pattern]);
					cacheDict[input] = output;
					return output;
				}
			}
			return null;
		}
		
		private function parseOutput(key:String, index:int):String
		{
			return "$" + index.toString();
		}
		
		private function parseInput(input:String):String
		{
			var result:String = input;
			for(var key:String in defineDict){
				result = replaceAll(result, key, parseInputImpl);
			}
			return result;
		}
		
		private function parseInputImpl(key:String, index:int):String
		{
			return defineDict[key];
		}
	}
}