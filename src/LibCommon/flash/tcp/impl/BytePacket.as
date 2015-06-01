package flash.tcp.impl
{
	import flash.tcp.IPacket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	public class BytePacket implements IPacket
	{
		private var _bodySize:uint;
		
		private var _msgId:uint;
		private var _msgData:ByteArray;
		
		public function BytePacket()
		{
		}
		
		public function create(msgId:uint=0, msgData:ByteArray=null):IPacket
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
			_bodySize = buffer.readUnsignedShort() - headSize;
			_msgId = buffer.readUnsignedShort();
		}
		
		public function readBody(buffer:IDataInput):void
		{
			if (_bodySize <= 0) return;
			_msgData = new ByteArray();
			_msgData.endian = endian;
			buffer.readBytes(_msgData, 0, _bodySize);
		}
		
		public function write(buffer:IDataOutput):void
		{
			if(null == _msgData || _msgData.length <= 0){
				buffer.writeShort(headSize);
				buffer.writeShort(msgId);
				return;
			}
			
			assert(_msgData.length <= 0xFFFF - headSize, "发送的数据大小不能超过64K!");
			
			buffer.writeShort(headSize + _msgData.length);
			buffer.writeShort(msgId);
			buffer.writeBytes(_msgData);
		}

		public function get msgId():uint
		{
			return _msgId;
		}

		public function get msgData():ByteArray
		{
			return _msgData;
		}
		
		public function get endian():String
		{
			return Endian.BIG_ENDIAN;
		}
		
		public function get errorId():uint
		{
			return _msgData.readUnsignedShort();
		}
	}
}