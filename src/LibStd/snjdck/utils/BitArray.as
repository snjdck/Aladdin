package snjdck.utils
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class BitArray
	{
		private var buffer:ByteArray;
		private var _byteIndex:int;
		private var _bitIndex:int;
		
		public function BitArray(bin:ByteArray)
		{
			buffer = bin;
			seek();
		}

		public function get byteIndex():int
		{
			return _byteIndex;
		}

		public function set byteIndex(value:int):void
		{
			_byteIndex = value;
			_bitIndex = 0;
		}

		public function get bitIndex():int
		{
			return _bitIndex;
		}

		public function set bitIndex(value:int):void
		{
			_byteIndex += value / 8;
			_bitIndex = value % 8;
		}
		
		public function seek():void
		{
			byteIndex = buffer.position;
		}
		
		public function alignToByte():void
		{
			if(bitIndex > 0){
				++byteIndex;
			}
			buffer.position = byteIndex;
		}
		
		private function getByte():uint
		{
			return buffer[byteIndex];
		}
		
		private function getOffset(i:int, n:int):uint
		{
			return (Endian.LITTLE_ENDIAN == buffer.endian) ? i : (n-1-i);
		}
		
		public function readBits(n:int):uint
		{
			var val:uint = 0;
			
			for(var i:int=0; i<n; i++){
				val |= ((getByte() >>> (7-bitIndex)) & 0x01) << (n-1-i);
				++bitIndex;
			}
			
			return val;
		}
	}
}