package flash.utils
{
	import flash.factory.newBuffer;
	
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
		
		static public function FormatInt(val:uint):String
		{
			var ba:ByteArray = newBuffer();
			ba.writeUnsignedInt(val);
			return FormatBin(ba);
		}
		
		static public function FormatFloat(val:Number):String
		{
			var ba:ByteArray = newBuffer();
			ba.writeFloat(val);
			return FormatBin(ba);
		}
		
		static public function FormatDouble(val:Number):String
		{
			var ba:ByteArray = newBuffer();
			ba.writeDouble(val);
			return FormatBin(ba);
		}
	}
}