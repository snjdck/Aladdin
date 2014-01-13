package snjdck.g3d.parser.ogre.support
{
	public class MeshChunkID
	{
		static public const HEADER							:uint = 0x1000;
		
		static public const MESH							:uint = 0x3000;
		
		static public const SUBMESH							:uint = 0x4000;
		static public const SUBMESH_OPERATION				:uint = 0x4010;
		static public const SUBMESH_BONE_ASSIGNMENT			:uint = 0x4100;
		static public const SUBMESH_TEXTURE_ALIAS			:uint = 0x4200;
		
		static public const GEOMETRY						:uint = 0x5000;
		static public const GEOMETRY_VERTEX_DECLARATION		:uint = 0x5100;
		static public const GEOMETRY_VERTEX_ELEMENT			:uint = 0x5110;
		static public const GEOMETRY_VERTEX_BUFFER			:uint = 0x5200;
		static public const GEOMETRY_VERTEX_BUFFER_DATA		:uint = 0x5210;
		
		static public const MESH_SKELETON_LINK				:uint = 0x6000;
		
		static public const MESH_BONE_ASSIGNMENT			:uint = 0x7000;
		
		static public const MESH_LOD						:uint = 0x8000;
		static public const MESH_LOD_USAGE 					:uint = 0x8100;
		static public const MESH_LOD_MANUAL 				:uint = 0x8110;
		static public const MESH_LOD_GENERATED 				:uint = 0x8120;
		
		static public const MESH_BOUNDS 					:uint = 0x9000;
		
		static public const SUBMESH_NAME_TABLE 				:uint = 0xA000;
		static public const SUBMESH_NAME_TABLE_ELEMENT 		:uint = 0xA100;
		
		static public const EDGE_LISTS				 		:uint = 0xB000;
		static public const EDGE_LIST_LOD				 	:uint = 0xB100;
		static public const EDGE_GROUP				 		:uint = 0xB110;
		
		static public const POSES				 			:uint = 0xC000;
		static public const POSE				 			:uint = 0xC100;
		static public const POSE_VERTEX				 		:uint = 0xC111;
		
		static public const ANIMATIONS				 		:uint = 0xD000;
		static public const ANIMATION				 		:uint = 0xD100;
		static public const ANIMATION_TRACK				 	:uint = 0xD110;
		static public const ANIMATION_MORPH_KEYFRAME		:uint = 0xD111;
		static public const ANIMATION_POSE_KEYFRAME			:uint = 0xD112;
		static public const ANIMATION_POSE_REF				:uint = 0xD113;
		
		static public const TABLE_EXTREMES					:uint = 0xE000;
	}
}