package flash.utils
{
	import string.repeat;
	import string.replaceAt;

	public class JsonUtil
	{
		static private const patternHexNumber:RegExp = /0x[0-9a-f]+/gi;
		static private const patternString:RegExp = /".*?"/g;
		static private const patternQuote:RegExp = /\\"/g;
		static private const patternComment:RegExp = /\/\*.*?\*\//gs;
		static private const patternComma:RegExp = /,(?=\s*[}\]])/g;
		
		static private const offsetList:Array = [];
		
		static public function Parse(text:String):Object
		{
			var oldText:String = text;
			text = text.replace(patternQuote, "##");
			text = text.replace(patternString, _replaceString);
			var info:Array;
			for(;;){
				info = patternComment.exec(text);
				if (info == null) break;
				var length:int = info[0].length;
				oldText = replaceAt(oldText, info.index, info.index+length, repeat(" ", length));
				text = replaceAt(text, info.index, info.index+length, repeat(" ", length));
			}
			for(;;){
				info = patternComma.exec(text);
				if (info == null) break;
				oldText = replaceAt(oldText, info.index, info.index+1, " ");
			}
			for(;;){
				info = patternHexNumber.exec(text);
				if (info == null) break;
				offsetList.push(info.index);
			}
			oldText = oldText.replace(patternHexNumber, _replaceHex);
			offsetList.length = 0;
			return JSON.parse(oldText);
		}
		
		static private function _replaceString(match:String, index:int, input:String):String
		{
			return repeat('#', match.length);
		}
		
		static private function _replaceHex(match:String, _:int, input:String):String
		{
			for each(var offset:int in offsetList){
				if(input.indexOf(match, offset) == offset){
					return parseInt(match).toString();
				}
			}
			return match;
		}
	}
}