package snjdck.g3d.geom
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import vec3.add;

	public class Matrix4x4
	{
		public const translation:Vector3D = new Vector3D();
		public const rotation:Quaternion = new Quaternion();
		public const scale:Vector3D = new Vector3D(1, 1, 1);
		
		public function Matrix4x4(){}
		
		public function identity():void
		{
			translation.setTo(0, 0, 0);
			rotation.setTo(0, 0, 0, 1);
			scale.setTo(1, 1, 1);
		}
		
		public function copyFrom(from:Matrix4x4):void
		{
			translation.copyFrom(from.translation);
			rotation.copyFrom(from.rotation);
			scale.copyFrom(from.scale);
		}
		
		public function prepend(other:Matrix4x4, result:Matrix4x4):void
		{
			rotation.rotateVector(other.translation, tempVector);
			vec3.add(translation, tempVector, result.translation);
			rotation.multiply(other.rotation, result.rotation);
		}
		
		public function invert():void
		{
			rotation.w = -rotation.w;
			rotation.rotateVector(translation, translation);
			translation.negate();
		}
		
		public function toMatrix(result:Matrix3D):void
		{
			rotation.toMatrix(result, translation, scale);
		}
		
		public function transformVectors(vIn:Vector.<Number>, vOut:Vector.<Number>):void
		{
			toMatrix(tempMatrix);
			tempMatrix.transformVectors(vIn, vOut);
		}
		
		static private const tempVector:Vector3D = new Vector3D();
		static private const tempMatrix:Matrix3D = new Matrix3D();
	}
}