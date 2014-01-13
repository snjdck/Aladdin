package snjdck.fileformat.dds
{
	import flash.utils.IDataInput;

	public class DDSPixelFormat
	{
		public static const DXT_1:int = 1;
		public static const DXT_2:int = 2;
		public static const DXT_3:int = 3;
		public static const DXT_4:int = 4;
		public static const DXT_5:int = 5;
		public static const DXT_UNKNOWN:int = 6;
		
		// DDSPixelFormat 的 Flags 字段可用标记如下
		public static const DDPF_ALPHAPIXELS:uint           = 0x00000001;
		public static const DDPF_FOURCC:uint                = 0x00000004;
		public static const DDPF_RGB:uint                   = 0x00000040;
		
		private var size:uint;
		private var flags:uint;
		private var fourCC:String;
		public var rgbBitCount:uint;
		public var rBitMask:uint;
		public var gBitMask:uint;
		public var bBitMask:uint;
		public var aBitMask:uint;
		
		public function DDSPixelFormat()
		{
		}
		
		public function hasFlag(flag:uint):Boolean
		{
			return (flags & flag) != 0;
		}
		
		public function read(buffer:IDataInput):void
		{
			size = buffer.readUnsignedInt();
			flags = buffer.readUnsignedInt();
			fourCC = buffer.readUTFBytes(4);
			rgbBitCount = buffer.readUnsignedInt();
			rBitMask = buffer.readUnsignedInt();
			gBitMask = buffer.readUnsignedInt();
			bBitMask = buffer.readUnsignedInt();
			aBitMask = buffer.readUnsignedInt();
		}
		
		public function getDXTFormat():int
		{
			var pattern:RegExp = /DXT(\d)/;
			var result:Array = pattern.exec(fourCC);
			
			if(null == result){
				return DXT_UNKNOWN;
			}
			
			var type:int = parseInt(result[1]);
			if (type >= 1 && type <= 5){
				return type;
			}
			return DXT_UNKNOWN;
		}
	}
}