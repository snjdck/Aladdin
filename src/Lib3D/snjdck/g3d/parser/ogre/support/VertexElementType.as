package snjdck.g3d.parser.ogre.support
{
	public class VertexElementType
	{
		static public const FLOAT1:uint = 0;
		static public const FLOAT2:uint = 1;
		static public const FLOAT3:uint = 2;
		static public const FLOAT4:uint = 3;
		// alias to more specific colour type - use the current rendersystem's colour packing
		static public const COLOUR:uint = 4;
		static public const SHORT1:uint = 5;
		static public const SHORT2:uint = 6;
		static public const SHORT3:uint = 7;
		static public const SHORT4:uint = 8;
		static public const UBYTE4:uint = 9;
		// D3D style compact colour
		static public const COLOUR_ARGB:uint = 10;
		// GL style compact colour
		static public const COLOUR_ABGR:uint = 11;
	}
}