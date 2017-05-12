package snjdck.fileformat.zip.writer
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class ZipWriter
	{
		static private const Version:int = 10;
		
		private const fileDict:Object = {};
		private var time:uint;
		
		public function ZipWriter()
		{
			time = calcTime();
		}
		
		public function addFile(name:String, data:ByteArray):void
		{
			fileDict[name] = data;
		}
		
		public function addString(name:String, data:String):void
		{
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(data);
			addFile(name, ba);
		}
		
		public function toByteArray():ByteArray
		{
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			
			var entryList:Array = [];
			var entry:ZipEntry;
			
			for(var fileName:String in fileDict){
				entry = new ZipEntry(fileName, fileDict[fileName], ba.position);
				entryList.push(entry);
				writeFileEntry(ba, entry);
			}
			var offset:uint = ba.position;
			for each(entry in entryList)
				writeDirectoryEntry(ba, entry);
			writeEnd(ba, entryList.length, ba.position - offset, offset);
			
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
			ba.writeUTF("");
		}
		
		private function writeInfo(ba:ByteArray, entry:ZipEntry):void
		{
			ba.writeShort(Version);
			ba.writeUnsignedInt(0);
			ba.writeUnsignedInt(time);
			ba.writeUnsignedInt(entry.crc32);
			ba.writeUnsignedInt(entry.sizeData);
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