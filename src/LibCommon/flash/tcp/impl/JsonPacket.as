package flash.tcp.impl
{
	import flash.lang.ISerializable;
	import flash.support.TypeCast;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	
	public class JsonPacket implements ISerializable
	{
		public var data:Object;
		
		public function JsonPacket(data:Object=null)
		{
			this.data = data;
		}
		
		public function readFrom(buffer:IDataInput):void
		{
			if(buffer!= null && buffer.bytesAvailable > 0){
				data = TypeCast.CastBytesToJson(buffer);
			}
		}
		
		public function writeTo(buffer:IDataOutput):void
		{
			var bytes:ByteArray = TypeCast.CastJsonToBytes(data);
			if(null != bytes){
				buffer.writeBytes(bytes);
			}
		}
	}
}