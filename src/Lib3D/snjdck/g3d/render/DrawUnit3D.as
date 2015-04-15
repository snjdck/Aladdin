package snjdck.g3d.render
{
	import flash.geom.Matrix3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.parser.IGeometry;
	import snjdck.g3d.skeleton.BoneStateGroup;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.AssetMgr;
	
	import string.replace;
	
	use namespace ns_g3d;

	final public class DrawUnit3D implements IDrawUnit3D
	{
		static public const PROJECTION_MATRIX_OFFSET:int = 0;
		static public const CAMERA_MATRIX_OFFSET:int = 2;
		static public const WORLD_MATRIX_OFFSET:int = 5;
		static public const BONE_MATRIX_OFFSET:int = 8;
		
		static private const MAX_VA_COUNT:uint = 8;
		static private const MAX_FS_COUNT:uint = 8;
		
		public var layer:uint;
		
		
		ns_g3d const worldMatrix:Matrix3D = new Matrix3D();
		
		public var shaderName:String;
		public var textureName:String;
		
		ns_g3d var blendMode:BlendMode;
		public const aabb:AABB = new AABB();
		
		public var geometry:IGeometry;
		public var boneStateGroup:BoneStateGroup;
		
		public function DrawUnit3D()
		{
			clear();
		}
		
		ns_g3d function clear():void
		{
			shaderName = null;
			textureName = null;
			
			blendMode = BlendMode.NORMAL;
		}
		
		public function draw(camera3d:CameraUnit3D, collector:DrawUnitCollector3D, context3d:GpuContext):void
		{
			context3d.program = AssetMgr.Instance.getProgram(shaderName);
			context3d.texture = AssetMgr.Instance.getTexture(textureName);
			context3d.blendMode = blendMode;
			geometry.draw(context3d, worldMatrix, boneStateGroup);
		}
		
		public function isOpaque():Boolean
		{
			return blendMode.equals(BlendMode.NORMAL);
		}
		
		public function getAABB():AABB
		{
			return aabb;
		}
		
		public function toString():String
		{
			return string.replace("{shader=${0}, texture=${1}}", [shaderName, textureName]);
		}
	}
}