package snjdck.fileformat.zip.writer
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class ZipWriter
	{
		static private const Version:int = 10;
		
		private const fileDict:Object = {};
		private var time:uint;
		private var entryCount:int;
		
		public function ZipWriter()
		{
			time = calcTime();
		}
		
		public function addFile(name:String, data:ByteArray, needCompress:Boolean=false):void
		{
			fileDict[name] = new ZipEntry(name, data, needCompress);
			++entryCount;
		}
		
		public function addString(name:String, data:String, needCompress:Boolean=false):void
		{
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(data);
			addFile(name, ba, needCompress);
		}
		
		public function toByteArray():ByteArray
		{
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			
			var entry:ZipEntry;
			
			for each(entry in fileDict){
				entry.offset = ba.position;
				writeFileEntry(ba, entry);
			}
			var offset:uint = ba.position;
			for each(entry in fileDict)
				writeDirectoryEntry(ba, entry);
			writeEnd(ba, entryCount, ba.position - offset, offset);
			
			ba.position = 0;
			return ba;
		}
		
		private function writeFileEntry(ba:ByteArray, entry:ZipEntry):void
		{
			ba.writeUnsignedInt(0x04034b50);
			writeInfo(ba, entry);
			ba.writeShort(entry.sizeName);
			ba.writeShort(0);
			ba.writeUTFBytes(entry.name);
			if(entry.sizeData > 0){
				ba.writeBytes(entry.data);
			}
		}
		
		private function writeDirectoryEntry(ba:ByteArray, entry:ZipEntry):void
		{
			ba.writeUnsignedInt(0x02014b50);
			ba.writeShort(Version);
			writeInfo(ba, entry);
			ba.writeShort(entry.sizeName);
			ba.writeUnsignedInt(0);
			ba.writeUnsignedInt(0);
			ba.writeUnsignedInt(0);
			ba.writeUnsignedInt(entry.offset);
			ba.writeUTFBytes(entry.name);
		}
		
		private function writeEnd(ba:ByteArray, entryCount:int, dirSize:uint, dirOffset:uint):void
		{
			ba.writeUnsignedInt(0x06054b50);
			ba.writeUnsignedInt(0);
			ba.writeShort(entryCount);
			ba.writeShort(entryCount);
			ba.writeUnsignedInt(dirSize);
			ba.writeUnsignedInt(dirOffset);
			ba.writeShort(0);
		}
		
		private function writeInfo(ba:ByteArray, entry:ZipEntry):void
		{
			ba.writeShort(Version);
			ba.writeShort(0);
			ba.writeShort(entry.compressionMethod);
			ba.writeUnsignedInt(time);
			ba.writeUnsignedInt(entry.crc32);
			ba.writeUnsignedInt(entry.sizeCompressedData);
			ba.writeUnsignedInt(entry.sizeData);
		}
		
		static private function calcTime():uint
		{
			var d:Date = new Date();
			return d.seconds >> 1
				| d.minutes << 5
				| d.hours << 11
				| d.day << 16
				| (d.month + 1) << 21
				| (d.fullYear - 1980 & 0x7F) << 25;
		}
	}
}