package snjdck.g3d.parser.ogre
{
	import flash.utils.ByteArray;
	
	import stream.readCString;

	internal class OgreParser
	{
		protected var buffer:ByteArray;
		
		public function OgreParser(ba:ByteArray)
		{
			buffer = ba;
		}
		
		public function readHeader():void
		{
			buffer.readUnsignedShort();	//header
			readCString(buffer);		//version
		}
		
		public function getChunkId():uint
		{
			var index:uint = buffer.position;
			return buffer[index] | (buffer[index+1] << 8);
		}
		
		public function getChunkDataSize():uint
		{
			buffer.position += 2;
			return buffer.readUnsignedInt() - 6;
		}
		
		public function seekToData():void
		{
			buffer.position += 6;
		}
		
		public function readUnknowChunk():void
		{
			var chunkId:uint = buffer.readUnsignedShort();
			var length:uint = buffer.readUnsignedInt();
			buffer.position += length - 6;
			
			var searchStr:String = chunkId.toString(16) + " - " + length.toString(16);
			trace("未解析:", searchStr);
		}
	}
}