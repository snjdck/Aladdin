package snjdck.fileformat.dds
{
	import flash.utils.IDataInput;

	internal class DDSCaps2
	{
		// DDSCaps2 的 Caps1 字段可用标记如下
		public static const DDSCAPS_COMPLEX:uint            = 0x00000008;
		public static const DDSCAPS_TEXTURE:uint            = 0x00001000;
		public static const DDSCAPS_MIPMAP:uint             = 0x00400000;
		
		// DDSCaps2 的 Caps2 字段可用标记如下
		public static const DDSCAPS2_CUBEMAP:uint           = 0x00000200;
		public static const DDSCAPS2_CUBEMAP_POSITIVEX:uint = 0x00000400;
		public static const DDSCAPS2_CUBEMAP_NEGATIVEX:uint = 0x00000800;
		public static const DDSCAPS2_CUBEMAP_POSITIVEY:uint = 0x00001000;
		public static const DDSCAPS2_CUBEMAP_NEGATIVEY:uint = 0x00002000;
		public static const DDSCAPS2_CUBEMAP_POSITIVEZ:uint = 0x00004000;
		public static const DDSCAPS2_CUBEMAP_NEGATIVEZ:uint = 0x00008000;
		public static const DDSCAPS2_VOLUME:uint            = 0x00200000;
		
		private var caps1:uint;
		private var caps2:uint;
		
		public function DDSCaps2()
		{
		}
		
		public function hasFlag(flag:uint):Boolean
		{
			return (caps2 & flag) != 0;
		}
		
		public function read(buffer:IDataInput):void
		{
			caps1 = buffer.readUnsignedInt();
			caps2 = buffer.readUnsignedInt();
			//reserved
			buffer.readUnsignedInt();
			buffer.readUnsignedInt();
		}
	}
}