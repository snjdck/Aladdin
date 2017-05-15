package flash.utils
{
	import string.repeat;
	import string.replaceAt;

	public class JsonUtil
	{
		static private const patternHexNumber:RegExp = /0x[0-9a-f]+/gi;
		static private const patternString:RegExp = /""|".*?[^\\]"/g;
		static private const patternComment1:RegExp = /\/\*.*?\*\//gs;
		static private const patternComment2:RegExp = /\/\/.*?(?=\n|$)/g;
		static private const patternComma:RegExp = /,(?=\s*[}\]])/g;
		
		static public function Parse(text:String):Object
		{
			var oldText:String = text;
			text = text.replace(patternString, _replaceString);
			var info:Array;
			for(;;){
				info = patternComment1.exec(text);
				if (info == null) break;
				oldText = replaceSpace(oldText, info);
			}
			for(;;){
				info = patternComment2.exec(text);
				if (info == null) break;
				oldText = replaceSpace(oldText, info);
			}
			for(;;){
				info = patternComma.exec(text);
				if (info == null) break;
				oldText = replaceSpace(oldText, info);
			}
			for(;;){
				info = patternHexNumber.exec(text);
				if (info == null) break;
				oldText = replaceHex(oldText, info);
			}
			oldText = oldText.replace(patternString, _replaceBlank);
			return JSON.parse(oldText);
		}
		
		static private function _replaceString(match:String, index:int, input:String):String
		{
			return repeat('#', match.length);
		}
		
		static private function _replaceBlank(match:String, index:int, input:String):String
		{
			return match.replace(/\t/g, "\\t");
		}
		
		static private function replaceSpace(text:String, info:Array):String
		{
			var offset:int = info.index;
			var length:int = info[0].length;
			return replaceAt(text, offset, offset+length, repeat(" ", length));
		}
		
		static private function replaceHex(text:String, info:Array):String
		{
			var hexText:String = info[0];
			var offset:int = info.index;
			var length:int = hexText.length;
			var numberText:String = parseInt(hexText).toString();
			while(numberText.length < length)
				numberText += " ";
			return replaceAt(text, offset, offset+length, numberText);
		}
	}
}