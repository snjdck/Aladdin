package snjdck.g3d.geom
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import matrix44.extractAxisX;
	import matrix44.transformVector;
	
	import vec3.crossProd;
	import vec3.dotProd;
	import vec3.subtract;

	public class OBB3
	{
		private var center:Vector3D;
		
		private var xAxis:Vector3D;
		private var yAxis:Vector3D;
		private var zAxis:Vector3D;
		
		private var halfSize:Vector3D;
		
		public function OBB3()
		{
			center = new Vector3D();
			xAxis = new Vector3D(1, 0, 0);
			yAxis = new Vector3D(0, 1, 0);
			zAxis = new Vector3D(0, 0, 1);
			halfSize = new Vector3D();
		}
		
		public function transform(matrix:Matrix3D, result:OBB3):void
		{
			matrix44.transformVector(matrix, center, result.center);
			
			matrix44.extractAxisX(matrix, xAxis);
			matrix44.extractAxisY(matrix, yAxis);
			matrix44.extractAxisZ(matrix, zAxis);
			
			result.halfSize.copyFrom(halfSize);
		}
		
		public function hitTest(other:OBB3):Boolean
		{
			vec3.subtract(other.center, center, ab);
			return test1(other) && other.test1(this)
				&& test2(other, xAxis, other.xAxis)
				&& test2(other, xAxis, other.yAxis)
				&& test2(other, xAxis, other.zAxis)
				&& test2(other, yAxis, other.xAxis)
				&& test2(other, yAxis, other.yAxis)
				&& test2(other, yAxis, other.zAxis)
				&& test2(other, zAxis, other.xAxis)
				&& test2(other, zAxis, other.yAxis)
				&& test2(other, zAxis, other.zAxis);
		}
		
		private function test1(other:OBB3):Boolean
		{
			return (absDot(ab, xAxis) - other.getProjectLen(xAxis) < halfSize.x)
				&& (absDot(ab, yAxis) - other.getProjectLen(yAxis) < halfSize.y)
				&& (absDot(ab, zAxis) - other.getProjectLen(zAxis) < halfSize.z);
		}
		
		private function test2(other:OBB3, selfAxis:Vector3D, otherAxis:Vector3D):Boolean
		{
			vec3.crossProd(selfAxis, otherAxis, axis);
			axis.normalize();
			return getProjectLen(axis) + other.getProjectLen(axis) > absDot(ab, axis);
		}
		
		private function getProjectLen(axis:Vector3D):Number
		{
			return halfSize.x * absDot(xAxis, axis) + halfSize.y * absDot(yAxis, axis) + halfSize.z * absDot(zAxis, axis);
		}
		
		private function absDot(a:Vector3D, b:Vector3D):Number
		{
			return Math.abs(vec3.dotProd(a, b));
		}
		
		static private const axis:Vector3D = new Vector3D();
		static private const ab:Vector3D = new Vector3D();
	}
}