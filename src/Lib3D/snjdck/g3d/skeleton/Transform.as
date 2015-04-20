package snjdck.g3d.skeleton
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.geom.Quaternion;
	
	import vec3.add;
	import vec3.interpolate;

	final public class Transform
	{
		static public function Interpolate(from:Transform, to:Transform, f:Number, result:Transform):void
		{
			vec3.interpolate(from.translation, to.translation, f, result.translation);
			Quaternion.Slerp(from.rotation, to.rotation, f, result.rotation);
		}
		
		public const translation:Vector3D = new Vector3D();
		public const rotation:Quaternion = new Quaternion();
		
		public function Transform(){}
		
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
		
		public function prepend(other:Transform, result:Transform):void
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
			rotation.toMatrix(result, translation);
		}
		
		public function transformVectors(vIn:Vector.<Number>, vOut:Vector.<Number>):void
		{
			toMatrix(tempMatrix);
			tempMatrix.transformVectors(vIn, vOut);
		}
		
		public function copyRawDataTo(output:Vector.<Number>, offset:int):void
		{
			output[offset  ] = rotation.x;
			output[offset+1] = rotation.y;
			output[offset+2] = rotation.z;
			output[offset+3] = rotation.w;
			output[offset+4] = translation.x;
			output[offset+5] = translation.y;
			output[offset+6] = translation.z;
			output[offset+7] = 1;				//scale
		}
		
		static private const tempVector:Vector3D = new Vector3D();
		static private const tempMatrix:Matrix3D = new Matrix3D();
	}
}