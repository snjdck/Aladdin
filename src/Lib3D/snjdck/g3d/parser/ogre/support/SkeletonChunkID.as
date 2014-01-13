package snjdck.g3d.parser.ogre.support
{
	public class SkeletonChunkID
	{
		static public const HEADER							:uint = 0x1000;
		static public const BONE							:uint = 0x2000;
		static public const BONE_PARENT						:uint = 0x3000;
		static public const ANIMATION						:uint = 0x4000;
		static public const ANIMATION_TRACK					:uint = 0x4100;
		static public const ANIMATION_TRACK_KEYFRAME		:uint = 0x4110;
		static public const ANIMATION_TRACK_KEYFRAME_TLBB	:uint = 0x4120;//天龙八部的自定义id
		static public const ANIMATION_LINK					:uint = 0x5000;
	}
}