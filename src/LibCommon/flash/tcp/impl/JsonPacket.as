package flash.tcp.impl
{
	import flash.tcp.IPacket;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	import string.replace;
	
	public class JsonPacket implements IPacket
	{
		static private const tempBuffer:ByteArray = new ByteArray();
		
		private var _bodySize:uint;
		
		private var _msgId:uint;
		private var _msgData:Object;
		
		public function JsonPacket()
		{
		}
		
		public function create(msgId:uint=0, msgData:Object=null):IPacket
		{
			var packet:JsonPacket = new JsonPacket();
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
			var body:String = buffer.readUTFBytes(_bodySize);
			_msgData = JSON.parse(body);
		}
		
		public function write(buffer:IDataOutput):void
		{
			if(null != msgData){
				var body:String = JSON.stringify(msgData);
				tempBuffer.writeUTFBytes(body);
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