package flash.tcp.impl
{
	import flash.tcp.IPacket;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	import string.replace;
	
	public class AmfPacket implements IPacket
	{
		static private const tempBuffer:ByteArray = new ByteArray();
		
		private var _bodySize:uint;
		
		private var _msgId:uint;
		private var _msgData:Object;
		
		public function AmfPacket()
		{
		}
		
		public function create(msgId:uint=0, msgData:Object=null):IPacket
		{
			var packet:AmfPacket = new AmfPacket();
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
			buffer.readBytes(tempBuffer, 0, _bodySize);
			_msgData = tempBuffer.readObject();
			tempBuffer.clear();
		}
		
		public function write(buffer:IDataOutput):void
		{
			if(null != msgData){
				tempBuffer.writeObject(msgData);
			}
			
			assert(tempBuffer.length <= 0xFFFF, "发送的数据大小不能超过64K!");
			
			buffer.writeShort(tempBuffer.length);
			buffer.writeShort(msgId);
			buffer.writeBytes(tempBuffer);
			
			tempBuffer.clear();
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