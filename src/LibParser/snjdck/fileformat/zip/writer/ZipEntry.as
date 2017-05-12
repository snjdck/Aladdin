package snjdck.fileformat.zip.writer
{
	import flash.crypto.CRC32;
	import flash.utils.ByteArray;
	
	import string.calcByteSize;

	internal class ZipEntry
	{
		public var name:String;
		public var data:ByteArray;
		public var offset:uint;
		public var crc32:uint;
		public var sizeName:uint;
		public var sizeData:uint;
		
		public function ZipEntry(name:String, data:ByteArray, offset:uint)
		{
			this.name = name;
			this.data = data;
			this.offset = offset;
			crc32 = CRC32.Compute(data);
			sizeName = calcByteSize(name);
			sizeData = data.length;
		}
	}
}