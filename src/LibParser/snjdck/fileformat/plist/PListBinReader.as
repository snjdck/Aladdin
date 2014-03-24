package snjdck.fileformat.plist
{
	import flash.debugger.enterDebugger;
	import flash.utils.ByteArray;

	public class PListBinReader
	{
		private var source:ByteArray;
		private var indexSize:int;
		private var objectRefSize:int;
		private var tableOffset:int;
		
		public function PListBinReader()
		{
		}
		
		public function read(source:ByteArray):Object
		{
			this.source = source;
			assert(source.readUTFBytes(8) == "bplist00");
			source.position = source.length - 32;
			source.position += 6;
			indexSize = source.readByte();
			objectRefSize = source.readByte();
			source.position += 4;
			var numberOfObjects:int = source.readInt();
			source.position += 4;
			var topObject:int = source.readInt();
			source.position += 4;
			tableOffset = source.readInt();
			
			return parseAt(topObject);
		}
		
		private function parseAt(index:int):*
		{
			source.position = tableOffset + indexSize * index;
			source.position = getIndex(indexSize);
			
			var marker:int = source.readUnsignedByte();
			var size:int = marker & 0x0F;
			var type:int = marker >> 4;
			
			if(type > 0 && size == 0x0F){
				size = getSize();
			}
			
			switch(type)
			{
				case 0x00:
					return readPrimitive(size);
				case 0x01:
					return readInt(size);
				case 0x02:
					return readReal(size);
				case 0x03:
					return readDate(size);
				case 0x04:
					var bytes:ByteArray = new ByteArray();
					if(size > 0){
						source.readBytes(bytes, 0, size);
					}
					return bytes;
				case 0x05:
					return source.readUTFBytes(size);
				case 0x06:
					return source.readMultiByte(size, "gb2312");
				case 0x0A:
					return readArr(size);
				case 0x0D:
					return readDic(size);
			}
			
			return null;
		}
		
		private function readPrimitive(size:int):Object
		{
			switch(size)
			{
				case 0x00:	return 0;
				case 0x08:	return false;
				case 0x09:	return true;
				case 0x0F:	return 0x0F;
			}
			return null;
		}
		
		private function readInt(size:int):Number
		{
			switch(size)
			{
				case 0:	return source.readUnsignedByte();
				case 1:	return source.readShort();
				case 2:	return source.readInt();
				case 3:
					var high:int = source.readInt();
					var low:uint = source.readUnsignedInt();
					return high * 0x100000000 + low;
			}
			return 0;
		}
		
		private function readReal(size:int):Number
		{
			switch(size)
			{
				case 2:	return source.readFloat();
				case 3: return source.readDouble();
			}
			return 0;
		}
		
		private function readDate(size:int):String
		{
			var date:Date = new Date(1000 * (readReal(size) + 978307200));
			return null;
		}
		
		private function readArr(size:int):Array
		{
			var offset:int = source.position;
			var list:Array = [];
			for(var i:int=0; i<size; ++i)
			{
				source.position = offset + objectRefSize * i;
				list[i] = parseAt(getIndex(objectRefSize));
			}
			return list;
		}
		
		private function readDic(size:int):Object
		{
			if(size <= 0){
				return null;
			}
			var offset:int = source.position;
			var obj:Object = {};
			for(var i:int=0; i<size; ++i)
			{
				source.position = offset + objectRefSize * i;
				var key:String = parseAt(getIndex(objectRefSize));
//				if(key == "originalWidth"){
//					enterDebugger();
//				}
				source.position = offset + objectRefSize * (i + size);
				var val:Object = parseAt(getIndex(objectRefSize));
				obj[key] = PListReader.processDictValue(key, val);
			}
			return obj;
		}
		
		private function getSize():int
		{
			var marker:int = source.readUnsignedByte();
			assert((marker >> 4) == 1);
			var n:int = 1 << (marker & 0x0F);
			var size:int = 0;
			for(var i:int=0; i<n; ++i){
				size = (size << 8) | source.readUnsignedByte();
			}
			return size;
		}
		
		private function getIndex(size:int):int
		{
			switch(size)
			{
				case 1:	return source.readUnsignedByte();
				case 2:	return source.readUnsignedShort();
				case 4:	return source.readUnsignedInt();
			}
			assert(false, "should not be here!");
			return 0;
		}
	}
}