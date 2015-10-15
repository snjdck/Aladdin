package snjdck.fileformat.csv
{
	public class ByteOrderMark
	{
		static public const UTF_32_BIG_ENDIAN:Array = [0x00, 0x00, 0xFE, 0xFF];
		static public const UTF_32_LITTLE_ENDIAN:Array = [0xFF, 0xFE, 0x00, 0x00];
		static public const UTF_16_BIG_ENDIAN:Array = [0xFE, 0xFF];
		static public const UTF_16_LITTLE_ENDIAN:Array = [0xFF, 0xFE];
		static public const UTF_8:Array = [0xEF, 0xBB, 0xBF];
	}
}