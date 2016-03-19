package protocols
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import math.isNumber;

	public class Bson
	{
		static public function Encode(obj:Object):ByteArray
		{
			var ba:ByteArray = new ByteArray();
			new Bson(ba).writeDoc(obj);
			return ba;
		}
		
		static public function Decode(buffer:ByteArray):Object
		{
			return new Bson(buffer).readDoc();
		}
		
		private var buffer:ByteArray;
		
		public function Bson(ba:ByteArray)
		{
			buffer = ba;
			buffer.endian = Endian.LITTLE_ENDIAN;
		}
		
		public function readDoc():Object
		{
			return readDocImp({});
		}
		
		private function readDocImp(output:Object):Object
		{
			buffer.position += 4;
			
			for(;;){
				var type:uint = buffer.readUnsignedByte();
				if(type == TERMINATOR)
					break;
				output[readCString()] = readData(type);
			}
			
			return output;
		}
		
		public function writeDoc(obj:Object):void
		{
			var index:uint = buffer.position;
			
			buffer.writeInt(0);
			for(var key:String in obj){
				writeData(key, obj[key]);
			}
			buffer.writeByte(TERMINATOR);
			
			var size:int = buffer.position - index;
			buffer.position = index;
			buffer.writeInt(size);
			buffer.position += size - 4;
		}
		
		private function readData(type:uint):Object
		{
			switch(type)
			{
				case DOUBLE:	return buffer.readDouble();
				case STRING:	return readString();
				case DOCUMENT:	return readDoc();
				case ARRAY:		return readDocImp([]);
				case BINARY:	return readBinary();
				case UNDEFINED:	return undefined;
				case OBJECT_ID:	return readObjectID();
				case BOOLEAN:	return buffer.readBoolean();
				case DATE:		return new Date(readInt64());
				case NULL:		return null;
				case REG_EXP:	return new RegExp(readCString(), readCString());
				case INT32:		return buffer.readInt();
				case INT64:		return readInt64();
				default: throw new ArgumentError();
			}
			return null;
		}
		
		private function writeData(key:String, val:*):void
		{
			var type:uint = getObjType(val);
			
			buffer.writeByte(type);
			writeCString(key);
			
			switch(type)
			{
				case DOUBLE:
					buffer.writeDouble(val);
					break;
				case STRING:
					writeString(val);
					break;
				case DOCUMENT:
				case ARRAY:
					writeDoc(val);
					break;
				case BINARY:
					writeBinary(val);
					break;
				case BOOLEAN:
					buffer.writeBoolean(val);
					break;
				case DATE:
					writeInt64(val.getTime());
					break;
				case UNDEFINED:
				case NULL:
					break;
				case INT32:
					buffer.writeInt(val);
					break;
			}
		}
		
		private function getObjType(obj:Object):uint
		{
			if(null == obj){
				return NULL;
			}
			
			if(isNumber(obj)){
				return (obj is int) ? INT32 : DOUBLE;
			}
			
			if(obj is String)	return STRING;
			if(obj is Boolean)	return BOOLEAN;
			if(obj is Array)	return ARRAY;
			if(obj is ByteArray)return BINARY;
			if(obj is Date)		return DATE;
			
			return DOCUMENT;
		}
		
		private function readCString():String
		{
			var index:uint = buffer.position;
			var size:uint = 0;
			
			while(buffer[index+size] != TERMINATOR){
				++size;
			}
			
			var val:String = buffer.readUTFBytes(size);
			++buffer.position;
			return val;
		}
		
		private function writeCString(val:String):void
		{
			buffer.writeUTFBytes(val);
			buffer.writeByte(TERMINATOR);
		}
		
		private function readString():String
		{
			var val:String = buffer.readUTFBytes(buffer.readInt()-1);
			++buffer.position;
			return val;
		}
		
		private function writeString(val:String):void
		{
			buffer.writeInt(0);
			
			var index:uint = buffer.position;
			
			buffer.writeUTFBytes(val);
			buffer.writeByte(TERMINATOR);
			
			var size:int = buffer.position - index;
			
			buffer.position = index - 4;
			buffer.writeInt(size);
			buffer.position += size;
		}
		
		private function readBinary():ByteArray
		{
			var size:int = buffer.readInt();
			var subtype:uint = buffer.readUnsignedByte();
			
			if(2 == subtype){
				size = buffer.readInt();
			}
			
			var ba:ByteArray = new ByteArray();
			buffer.readBytes(ba, 0, size);
			return ba;
		}
		
		private function writeBinary(bin:ByteArray):void
		{
			buffer.writeInt(bin.length);
			buffer.writeByte(0);
			buffer.writeBytes(bin);
		}
		
		private function readObjectID():String
		{
			var objID:String = "";
			for(var i:int=0; i<12; i++){
				var byte:uint = buffer.readUnsignedByte();
				var hex:String = byte.toString(16);
				objID += (byte > 0xF) ? hex : ("0" + hex);
			}
			return objID;
		}
		
		private function readInt64():Number
		{
			var low:uint = buffer.readUnsignedInt();
			var high:uint = buffer.readUnsignedInt();
			return low + high * INT64_BASE;
		}
		
		private function writeInt64(value:Number):void
		{
			buffer.writeUnsignedInt(value % INT64_BASE);
			buffer.writeUnsignedInt(value / INT64_BASE);
		}
		
		static public const INT64_BASE:Number = 0x100000000;
		
		static public const TERMINATOR		:uint = 0x00;
		static public const DOUBLE			:uint = 0x01;
		static public const STRING			:uint = 0x02;
		static public const DOCUMENT		:uint = 0x03;
		static public const ARRAY			:uint = 0x04;
		static public const BINARY			:uint = 0x05;
		static public const UNDEFINED		:uint = 0x06;
		static public const OBJECT_ID		:uint = 0x07;
		static public const BOOLEAN			:uint = 0x08;
		static public const DATE			:uint = 0x09;
		static public const NULL			:uint = 0x0A;
		static public const REG_EXP			:uint = 0x0B;
		static public const INT32			:uint = 0x10;
		static public const TIMESTAMP		:uint = 0x11;
		static public const INT64			:uint = 0x12;
	}
}