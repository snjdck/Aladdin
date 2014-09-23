package snjdck.g3d.skeleton
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.geom.Quaternion;
	
	import string.replace;
	
	import vec3.add;
	import vec3.interpolate;

	final internal class Transform
	{
		static public function Interpolate(from:Transform, to:Transform, f:Number, result:Transform):void
		{
			vec3.interpolate(from.translation, to.translation, f, result.translation);
			Quaternion.Slerp(from.rotation, to.rotation, f, result.rotation);
		}
		
		public var translation:Vector3D;
		public var rotation:Quaternion;
		
		public function Transform()
		{
			translation = new Vector3D(0, 0, 0);
			rotation = new Quaternion();
		}
		
		public function copyFrom(from:Transform):void
		{
			translation.copyFrom(from.translation);
			rotation.copyFrom(from.rotation);
		}
		
		public function reset():void
		{
			translation.setTo(0, 0, 0);
			rotation.setTo(0, 0, 0, 1);
		}
		
		public function concat(other:Transform, result:Transform):void
		{
			rotation.rotateVector(other.translation, tempVector);
			vec3.add(translation, tempVector, result.translation);
			rotation.multiply(other.rotation, result.rotation);
		}
		
		public function toMatrix(result:Matrix3D):void
		{
			rotation.toMatrix(result, translation);
		}
		
		static private const tempVector:Vector3D = new Vector3D();
		
		public function toString():String
		{
			var axis:Vector3D = new Vector3D();
			rotation.toAxisAngle(axis);
			return replace("rotation:x=${x},y=${y},z=${z},angle=${w}", axis);
		}
	}
}