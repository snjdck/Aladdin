package snjdck.net.protocols
{
	import flash.utils.ByteArray;
	
	final public class Base64
	{
		static public function Encode(normalString:String):String
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(normalString);
			var base64String:String = EncodeImp(bytes);
			bytes.clear();
			return base64String;
		}
				
		static public function Decode(base64String:String):String
		{
			var bytes:ByteArray = DecodeImp(base64String);
			var normalString:String = bytes.readUTFBytes(bytes.length);
			bytes.clear();
			return normalString;
		}
		
		static private function EncodeImp(data:ByteArray):String
		{
			var output:String = "";
			var n:int = data.length;
			
			for(var i:int=0; i<n; i+=3){
				var a:int = data[i];
				var b:int = data[i+1];
				var c:int = data[i+2];
				
				var t1:int = (a & 0xFC) >> 2;
				var t2:int = ((a & 0x03) << 4) | (b >> 4);
				var t3:int = ((b & 0x0F) << 2) | (c >> 6);
				var t4:int = c & 0x3F;
				
				if(i+2 >= n){
					t4 = 64;
				}
				
				if(i+1 >= n){
					t3 = 64;
				}
				
				output += BASE64_DICT.charAt(t1) + BASE64_DICT.charAt(t2) + BASE64_DICT.charAt(t3) + BASE64_DICT.charAt(t4);
			}
			
			return output;
		}
		
		static private function DecodeImp(data:String):ByteArray
		{
			var output:ByteArray = new ByteArray();
			var n:int = data.length;
			
			for(var i:int=0; i<n; i+=4){
				var t1:int = BASE64_DICT.indexOf(data.charAt(i));
				var t2:int = BASE64_DICT.indexOf(data.charAt(i+1));
				var t3:int = BASE64_DICT.indexOf(data.charAt(i+2));
				var t4:int = BASE64_DICT.indexOf(data.charAt(i+3));
				
				var a:int = (t1 << 2) | ((t2 >> 4) & 0x03);
				var b:int = ((t2 & 0x0F) << 4) | ((t3 >> 2) & 0x0F);
				var c:int = ((t3 & 0x03) << 6) | t4;
				
				output.writeByte(a);
				
				if(t3 < 64){
					output.writeByte(b);
				}
				
				if(t4 < 64){
					output.writeByte(c);
				}
			}
			
			output.position = 0;
			return output;
		}
		
		static private const BASE64_DICT:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	}
}