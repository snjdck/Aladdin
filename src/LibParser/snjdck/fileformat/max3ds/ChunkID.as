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
		static public const MESH_MATER	:uint = 0x4130;
		static public const UVS			:uint = 0x4140;
		static public const TRI_SMOOTH	:uint = 0x4150;
		static public const TRI_LOCAL	:uint = 0x4160;
		
		
		static public const KEYFRAME	:uint = 0xB000;
		static public const KEYF_OBJDES	:uint = 0xB002;
		static public const KEYF_FRAME_COUNT:uint = 0xB008;
		
//		static public const EDIT_CONFIG1:uint = 0x0100;
		static public const EDITOR_CONFIG:uint = 0x3D3E;
		static public const MATERIAL_LIST:uint = 0xAFFF;
		static public const MATERIAL_NAME:uint = 0xA000;
		
		static public const MAT_AMBIENT		:uint = 0xA010;
		static public const MAT_DIFFUSE		:uint = 0xA020;
		static public const MAT_SPECULAR	:uint = 0xA030;
		static public const MAT_SHININESS	:uint = 0xA040;
		static public const MAT_TEXMAP		:uint = 0xA200;
		static public const MAT_TEXFLNM		:uint = 0xA300;
		
		static public const COLOR_F:uint = 0x10;
		static public const COLOR_RGB:uint = 0x11;
	}
}