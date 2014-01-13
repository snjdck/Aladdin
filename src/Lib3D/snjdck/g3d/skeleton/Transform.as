package snjdck.g3d.skeleton
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.geom.Quaternion;
	
	import string.replace;
	
	import vec3.interpolate;

	final public class Transform
	{
		static public function Interpolate(from:Transform, to:Transform, f:Number, result:Transform):void
		{
			vec3.interpolate(from.translation, to.translation, f, result.translation);
			Quaternion.Slerp(from.rotation, to.rotation, f, result.rotation);
			vec3.interpolate(from.scale, to.scale, f, result.scale);
		}
		
		public var translation:Vector3D;
		public var rotation:Quaternion;
		public var scale:Vector3D;
		
		public function Transform()
		{
			translation = new Vector3D(0, 0, 0);
			rotation = new Quaternion();
			scale = new Vector3D(1, 1, 1);
		}
		
		public function copyFrom(from:Transform):void
		{
			translation.copyFrom(from.translation);
			rotation.copyFrom(from.rotation);
			scale.copyFrom(from.scale);
		}
		
		public function reset():void
		{
			translation.setTo(0, 0, 0);
			rotation.setTo(0, 0, 0, 1);
			scale.setTo(1, 1, 1);
		}
		
		public function toString():String
		{
			var axis:Vector3D = new Vector3D();
			rotation.toAxisAngle(axis);
			return replace("rotation:x=${x},y=${y},z=${z},angle=${w}", axis);
		}
	}
}