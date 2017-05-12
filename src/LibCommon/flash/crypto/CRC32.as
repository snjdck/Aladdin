package flash.crypto
{
	import flash.utils.ByteArray;

	final public class CRC32
	{
		static private const table:Array = MakeTable();
		
		static private function MakeTable():Array
		{
			var crcTable:Array = new Array(256);
			for(var n:int = 0; n < 256; ++n){
				var c:uint = n;
				for(var i:int = 0; i < 8; ++i){
					c = (c & 1) != 0 ? 0xedb88320 ^ (c >>> 1) : (c >>> 1);
				}
				crcTable[n] = c;
			}
			return crcTable;
		}
		
		static public function Compute(ba:ByteArray):uint
		{
			var crc:uint = 0xFFFFFFFF;
			for(var i:int=0, n:int=ba.length; i<n; ++i)
				crc = table[(crc ^ ba[i]) & 0xFF] ^ (crc >>> 8);
			return ~crc;
		}
	}
}