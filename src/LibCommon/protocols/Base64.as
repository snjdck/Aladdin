package protocols
{
	import flash.utils.ByteArray;
	
	final public class Base64
	{
		static public function Encode(normalString:String):String
		{
			buffer.clear();
			buffer.writeUTFBytes(normalString);
			return EncodeImp(buffer);
		}
				
		static public function Decode(base64String:String):String
		{
			buffer.clear();
			DecodeImp(base64String, buffer);
			buffer.position = 0;
			return buffer.readUTFBytes(buffer.length);
		}
		
		static private function EncodeImp(data:ByteArray):String
		{
			var output:Array = [];
			for(var i:int=0,n:int=data.length; i<n; i+=3)
			{
				var a:int = data[i];
				var b:int = data[i+1];
				var c:int = data[i+2];
				
				var t1:int = (a & 0xFC) >> 2;
				var t2:int = ((a & 0x03) << 4) | (b >> 4);
				var t3:int = ((b & 0x0F) << 2) | (c >> 6);
				var t4:int = c & 0x3F;
				
				if (i+1 >= n) t3 = 64;
				if (i+2 >= n) t4 = 64;
				
				output.push(charList.charAt(t1), charList.charAt(t2), charList.charAt(t3), charList.charAt(t4));
			}
			return output.join("");
		}
		
		static private function DecodeImp(data:String, output:ByteArray):void
		{
			for(var i:int=0,n:int=data.length; i<n; i+=4)
			{
				var t1:int = charList.indexOf(data.charAt(i));
				var t2:int = charList.indexOf(data.charAt(i+1));
				var t3:int = charList.indexOf(data.charAt(i+2));
				var t4:int = charList.indexOf(data.charAt(i+3));
				
				var a:int = (t1 << 2) | ((t2 >> 4) & 0x03);
				var b:int = ((t2 & 0x0F) << 4) | ((t3 >> 2) & 0x0F);
				var c:int = ((t3 & 0x03) << 6) | t4;
				
				output.writeByte(a);
				
				if (t3 < 64) output.writeByte(b);
				if (t4 < 64) output.writeByte(c);
			}
		}
		
		static private const buffer:ByteArray = new ByteArray();
		static private const charList:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	}
}