package protocols
{
	import flash.utils.ByteArray;
	
	final public class Base64
	{
		static public function EncodeString(normalString:String):String
		{
			buffer.clear();
			buffer.writeUTFBytes(normalString);
			return Encode(buffer);
		}
				
		static public function DecodeString(base64String:String):String
		{
			buffer.clear();
			DecodeImp(base64String, buffer);
			buffer.position = 0;
			return buffer.readUTFBytes(buffer.length);
		}
		
		static public function Decode(base64String:String):ByteArray
		{
			var ba:ByteArray = new ByteArray();
			DecodeImp(base64String, ba);
			return ba;
		}
		
		static public function Encode(data:ByteArray):String
		{
			var output:Array = [];
			for(var i:int=0, n:int=data.length; i<n; i+=3)
			{
				var value:int = data[i] << 16 | data[i+1] << 8 | data[i+2];
				
				var t1:int = value >> 18;
				var t2:int = value >> 12 & 0x3F;
				var t3:int = value >>  6 & 0x3F;
				var t4:int = value & 0x3F;
				
				if (i+1 >= n) t3 = 64;
				if (i+2 >= n) t4 = 64;
				
				output.push(charList.charAt(t1), charList.charAt(t2), charList.charAt(t3), charList.charAt(t4));
			}
			return output.join("");
		}
		
		static private function DecodeImp(data:String, output:ByteArray):void
		{
			for(var i:int=0, n:int=data.length; i<n; i+=4)
			{
				var t1:int = charList.indexOf(data.charAt(i));
				var t2:int = charList.indexOf(data.charAt(i+1));
				var t3:int = charList.indexOf(data.charAt(i+2));
				var t4:int = charList.indexOf(data.charAt(i+3));
				
				var value:int = t1 << 18 | t2 << 12 | t3 << 6 | t4;
				
				output.writeByte(value >> 16);
				
				if (t3 < 64) output.writeByte(value >> 8 & 0xFF);
				if (t4 < 64) output.writeByte(value & 0xFF);
			}
		}
		
		static private const buffer:ByteArray = new ByteArray();
		static private const charList:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	}
}