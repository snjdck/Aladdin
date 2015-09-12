package flash.utils
{
	import avm2.intrinsics.memory.li8;
	import avm2.intrinsics.memory.sf32;
	import avm2.intrinsics.memory.sf64;
	import avm2.intrinsics.memory.si32;
	
	import string.formatInt;

	final public class HexUtil
	{
		static public function FormatBin(bin:ByteArray, begin:uint=0, length:uint=0, separator:String=null):String
		{
			if(0 == length){
				length = bin.length;
			}
			
			var str:String = "";
			for(var i:int=0; i<length; i++){
				if(separator && (i % 4 == 0) && (i > 0)){
					str += separator;
				}
				str += formatInt(bin[begin+i], 2, 16);
			}
			return str;
		}
		/** 低字节序 */
		static public function FormatInt(val:uint):String
		{
			si32(val, 0);
			return ReadString(4);
		}
		/** 低字节序 */
		static public function FormatFloat(val:Number):String
		{
			sf32(val, 0);
			return ReadString(4);
		}
		/** 低字节序 */
		static public function FormatDouble(val:Number):String
		{
			sf64(val, 0);
			return ReadString(8);
		}
		
		static private function ReadString(count:int):String
		{
			var result:Array = [];
			for(var i:int=0; i<count; ++i){
				result[i] = formatInt(li8(i), 2, 16);
			}
			return result.join("");
		}
		
		static public function BytesToString(bytes:ByteArray):String
		{
			var n:int = bytes.length;
			var list:Array = [];
			for(var i:int=0; i<n; ++i){
				list[i] = formatInt(bytes[i], 2, 16);
			}
			return list.join(" ");
		}
		
		static private const blankExp:RegExp = /\s+/;
		
		public static function StringToBytes(str:String):ByteArray
		{
			var result:ByteArray = new ByteArray();
			var list:Array = str.split(blankExp);
			for each(var item:String in list){
				if(!Boolean(item)){
					continue;
				}
				while(item.length > 2){
					result.writeByte(parseInt(item.slice(0, 2),16));
					item = item.slice(2);
				}
				if(item.length > 0){
					result.writeByte(parseInt(item,16));
				}
			}
			result.position = 0;
			return result;
		}
	}
}