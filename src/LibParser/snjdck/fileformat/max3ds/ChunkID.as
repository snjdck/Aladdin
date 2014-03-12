package snjdck.fileformat.max3ds
{
	internal class ChunkID
	{
		static public const HEADER		:uint = 0x4d4d;
		static public const VERSION		:uint = 0x0002;
		static public const EDITOR		:uint = 0x3d3d;
		static public const OBJECTS		:uint = 0x4000;
		static public const MESH		:uint = 0x4100;
		static public const VERTICES	:uint = 0x4110;
		static public const INDICES		:uint = 0x4120;
		static public const UVS			:uint = 0x4140;
		static public const KEYFRAME	:uint = 0xB000;
	}
}