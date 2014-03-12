package flash.tcp.impl
{
	import flash.tcp.IPacket;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	import string.replace;
	
	public class BytePacket implements IPacket
	{
		private var _bodySize:uint;
		
		private var _msgId:uint;
		private var _msgData:Object;
		
		public function BytePacket()
		{
		}
		
		public function create(msgId:uint=0, msgData:Object=null):IPacket
		{
			var packet:BytePacket = new BytePacket();
			packet._msgId = msgId;
			packet._msgData = msgData;
			return packet;
		}
		
		public function get headSize():uint
		{
			return 4;
		}
		
		public function get bodySize():uint
		{
			return _bodySize;
		}
		
		public function readHead(buffer:IDataInput):void
		{
			_bodySize = buffer.readUnsignedShort();
			_msgId = buffer.readUnsignedShort();
		}
		
		public function readBody(buffer:IDataInput):void
		{
			if(_bodySize <= 0){
				return;
			}
			var tempBuffer:ByteArray = new ByteArray();
			buffer.readBytes(tempBuffer, 0, _bodySize);
			_msgData = tempBuffer;
		}
		
		public function write(buffer:IDataOutput):void
		{
			if(null == _msgData){
				buffer.writeShort(0);
				buffer.writeShort(msgId);
				return;
			}
			
			var tempBuffer:ByteArray = _msgData as ByteArray;
			assert(tempBuffer.length <= 0xFFFF, "发送的数据大小不能超过64K!");
			
			buffer.writeShort(tempBuffer.length);
			buffer.writeShort(msgId);
			buffer.writeBytes(tempBuffer);
		}

		public function get msgId():uint
		{
			return _msgId;
		}

		public function get msgData():*
		{
			return _msgData;
		}
		
		public function toString():String
		{
			return string.replace("[msgId=${0}, msgData=${1}]", [msgId, JSON.stringify(msgData)]);
		}
	}
}