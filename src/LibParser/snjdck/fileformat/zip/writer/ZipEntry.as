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
		public var sizeCompressedData:uint;
		public var compressionMethod:int;
		
		public function ZipEntry(name:String, data:ByteArray, needCompress:Boolean)
		{
			this.name = name;
			this.data = data;
			sizeName = calcByteSize(name);
			crc32 = CRC32.Compute(data);
			sizeData = data.length;
			if(needCompress && data.length > 0){
				compressionMethod = 8;
				data.deflate();
			}
			sizeCompressedData = data.length;
		}
	}
}