package snjdck.shader
{
	/**
	 * 投影纹理,就是将最后的顶点坐标映射到[0,1]的uv坐标,再传递给v0
	 */	
	public class ShaderName
	{
		static public const DYNAMIC_OBJECT:String = "bone_ani";
		static public const STATIC_OBJECT:String = "object";
		static public const BILLBOARD:String = "billboard";
		
		static public const IMAGE:String = "image";
		static public const IMAGE_DXT5:String = "image_dxt5";
		static public const BLUR:String = "blur";
		static public const COLOR_MATRIX:String = "color_matrix";
		
		static public const PARTICLE_2D:String = "particle2d";
//		static public const G2D_DRAW_SCREEN:String = "g2d_drawScreen";
//		static public const G2D:String = "g2d";
		static public const G2D_PRE_DRAW_DEPTH:String = "g2d_preDrawDepth";
		static public const G3D_PRE_DRAW_DEPTH:String = "g3d_preDrawDepth";
		
		static public const TEXT_2D:String = "text2d";
	}
}