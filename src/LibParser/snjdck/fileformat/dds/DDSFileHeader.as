package snjdck.fileformat.dds
{
	import flash.utils.IDataInput;

	public class DDSFileHeader
	{
		// DDSFileHeader 的 Flags 字段可用标记如下
		public static const DDSD_CAPS:uint                  = 0x00000001;
		public static const DDSD_HEIGHT:uint                = 0x00000002;
		public static const DDSD_WIDTH:uint                 = 0x00000004;
		public static const DDSD_PITCH:uint                 = 0x00000008;
		public static const DDSD_PIXELFORMAT:uint           = 0x00001000;
		public static const DDSD_MIPMAPCOUNT:uint           = 0x00020000;
		public static const DDSD_LINEARSIZE:uint            = 0x00080000;
		public static const DDSD_DEPTH:uint                 = 0x00800000;
		
		private var size:uint;
		private var flags:uint;
		public var height:uint;
		public var width:uint;
		public var pitchOrLinearSize:uint;
		public var depth:uint;
		public var mipMapCount:uint;
		public const ddpfPixelFormat:DDSPixelFormat = new DDSPixelFormat();
		public const ddsCaps:DDSCaps2 = new DDSCaps2();
		
		public function DDSFileHeader()
		{
		}
		
		public function hasFlag(flag:uint):Boolean
		{
			return (flags & flag) != 0;
		}
		
		public function read(buffer:IDataInput):void
		{
			size = buffer.readUnsignedInt();//124
			flags = buffer.readUnsignedInt();
			height = buffer.readUnsignedInt();
			width = buffer.readUnsignedInt();
			pitchOrLinearSize = buffer.readUnsignedInt();
			depth = buffer.readUnsignedInt();
			mipMapCount = buffer.readUnsignedInt();
			//reserved1
			for(var i:int=0; i<11; i++){
				buffer.readUnsignedInt();
			}
			ddpfPixelFormat.read(buffer);//32
			ddsCaps.read(buffer);//16
			//reserved2
			buffer.readUnsignedInt();
		}
	}
}