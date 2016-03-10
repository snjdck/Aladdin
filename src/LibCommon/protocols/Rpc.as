package protocols
{
	import flash.utils.ByteArray;

	public class Rpc
	{
		static public function Encode(cmd:String, args:Array):ByteArray
		{
			var result:ByteArray = new ByteArray();
			
			result.writeByte(0);
			result.writeByte(3);
			
			result.writeShort(0);
			
			result.writeShort(1);
				result.writeUTF(cmd);
				result.writeUTF("/0");
					var body:ByteArray = new ByteArray();
					new Rpc(body).writeArray(args);
				result.writeUnsignedInt(body.length);
				result.writeBytes(body);
					body.clear();
			
			return result;
		}
		
		static public function Decode(buffer:ByteArray):Array
		{
			var ok:Boolean;
			var data:Object;
			
			buffer.readUnsignedByte();
			buffer.readUnsignedByte();
			
			var headCount:int = buffer.readUnsignedShort();
			while(headCount-- > 0){
				buffer.readUTF();//name
				buffer.readBoolean();//required
				buffer.readUnsignedInt();//content size
				new Rpc(buffer).readData();//content
			}
			
			var bodyCount:int = buffer.readUnsignedShort();
			while(bodyCount-- > 0){
				ok = buffer.readUTF().indexOf("/onResult") != -1;
				buffer.readUTF();
				buffer.readUnsignedInt();
				data = new Rpc(buffer).readData();
			}
			
			return [ok, data];
		}
		
		private var buffer:ByteArray;
		
		public function Rpc(ba:ByteArray)
		{
			buffer = ba;
		}
		
		public function readData():Object
		{
			switch(buffer.readUnsignedByte())
			{
				case 0: return buffer.readDouble();							//Number
				case 1: return buffer.readBoolean();						//Boolean
				case 2: return buffer.readUTF();							//String
				case 3: return readObject({});
				case 5: return null;
				case 6: return undefined;
					//case 7: return readRef();
				case 8: return readMixedArray();
				case 10: return readArray();
					//case 11: return readDate();
				case 12: return readUTF2();								//长度大于2^16的字符串
				case 15: return XML(readUTF2());						//XML
				case 16: return readCustomClass();
				case 17: return buffer.readObject();
				default: throw new ArgumentError();
			}
		}
		
		public function writeData(obj:Object):void
		{
			buffer.writeByte(17);
			buffer.writeObject(obj);
		}
		
		private function readObject(result:Object):*
		{
			for(;;){
				var key:String = buffer.readUTF();
				if(9 == buffer[buffer.position])
					break;
				result[key] = readData();
			}
			
			return result;
		}
		
		private function readMixedArray():Array
		{
			buffer.readUnsignedInt();//数组长度
			return readObject([]);
		}
		
		private function readArray():Array
		{
			var result:Array = [];
			
			var n:uint = buffer.readUnsignedInt();
			for (var i:int=0; i<n; i++){
				result[i] = readData();
			}
			
			return result;
		}
		
		public function writeArray(list:Array):void
		{
			var n:uint = list.length;
			
			buffer.writeByte(10);
			buffer.writeUnsignedInt(n);
			
			for(var i:int=0; i<n; i++){
				writeData(list[i]);
			}
		}
		
		private function readUTF2():String
		{
			return buffer.readUTFBytes(buffer.readUnsignedInt());
		}
		
		private function readCustomClass():Object
		{
			buffer.readUTF();
			return readObject({});
		}
	}
}