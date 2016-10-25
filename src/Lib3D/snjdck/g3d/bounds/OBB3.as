package snjdck.g3d.bounds
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import matrix44.extractAxisX;
	import matrix44.transformVector;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.cameras.IViewFrustum;
	
	import vec3.crossProd;
	import vec3.crossProdAxisX;
	import vec3.crossProdAxisY;
	import vec3.crossProdAxisZ;
	import vec3.dotProd;
	import vec3.subtract;
	
	use namespace ns_g3d;
	
	/**
	 * 计算开销太大
	 */
	internal class OBB3 extends Sphere implements IBoundingBox
	{
		private var xAxis:Vector3D;
		private var yAxis:Vector3D;
		private var zAxis:Vector3D;
		
		private var halfSize:Vector3D;
		
		public function OBB3()
		{
			xAxis = new Vector3D(1, 0, 0);
			yAxis = new Vector3D(0, 1, 0);
			zAxis = new Vector3D(0, 0, 1);
			halfSize = new Vector3D();
		}
		
		public function setCenterAndSize(center:Vector3D, size:Vector3D):void
		{
			this.center.copyFrom(center);
			halfSize = size;
			halfSize.scaleBy(0.5);
			radius = halfSize.length;
		}
		
		public function transform(matrix:Matrix3D, result:OBB3):void
		{
			matrix44.transformVector(matrix, center, result.center);
			
			matrix44.extractAxisX(matrix, result.xAxis);
			result.xAxis.normalize();
			matrix44.extractAxisY(matrix, result.yAxis);
			result.yAxis.normalize();
			matrix44.extractAxisZ(matrix, result.zAxis);
			result.zAxis.normalize();
			
			result.halfSize.copyFrom(halfSize);
			result.radius = radius;
		}
		/*
		public function hitTest(other:OBB3):Boolean
		{
			vec3.subtract(other.center, center, ab);
			var totalRadius:Number = radius + other.radius;
			if(ab.lengthSquared >= totalRadius * totalRadius){
				return false;
			}
			return hitTestAxis(other, ab)
				&& other.hitTestAxis(this, ab)
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
		*/
		public function hitTestAxis(other:IBoundingBox, ab:Vector3D):Boolean
		{
			return (absDot(ab, xAxis) - other.getProjectLen(xAxis) < halfSize.x)
				&& (absDot(ab, yAxis) - other.getProjectLen(yAxis) < halfSize.y)
				&& (absDot(ab, zAxis) - other.getProjectLen(zAxis) < halfSize.z);
		}
		
		private function test2(other:IBoundingBox, selfAxis:Vector3D, otherAxis:Vector3D):Boolean
		{
			vec3.crossProd(selfAxis, otherAxis, axis);
			axis.normalize();
			return getProjectLen(axis) + other.getProjectLen(axis) > absDot(ab, axis);
		}
		
		public function getProjectLen(axis:Vector3D):Number
		{
			return halfSize.x * absDot(xAxis, axis) + halfSize.y * absDot(yAxis, axis) + halfSize.z * absDot(zAxis, axis);
		}
		
		private function absDot(a:Vector3D, b:Vector3D):Number
		{
			return Math.abs(vec3.dotProd(a, b));
		}
		
		static private const axis:Vector3D = new Vector3D();
		static private const ab:Vector3D = new Vector3D();
		
		public function hitTestAABB(other:AABB):Boolean
		{
//			return hitTestSphere(other);
				return false;
			/*
			}
			return true;
			other.updateSize();
			
			return other.hitTestAxis(this, ab)
				&& hitTestAxis(other, ab)
				&& testX(other, xAxis)
				&& testY(other, xAxis)
				&& testZ(other, xAxis)
				&& testX(other, yAxis)
				&& testY(other, yAxis)
				&& testZ(other, yAxis)
				&& testX(other, zAxis)
				&& testY(other, zAxis)
				&& testZ(other, zAxis);
			*/
		}
		/*
		private function testX(other:IBoundingBox, selfAxis:Vector3D):Boolean
		{
			vec3.crossProdAxisX(selfAxis, axis);
			axis.normalize();
			return getProjectLen(axis) + other.getProjectLen(axis) > absDot(ab, axis);
		}
		
		private function testY(other:IBoundingBox, selfAxis:Vector3D):Boolean
		{
			vec3.crossProdAxisY(selfAxis, axis);
			axis.normalize();
			return getProjectLen(axis) + other.getProjectLen(axis) > absDot(ab, axis);
		}
		
		private function testZ(other:IBoundingBox, selfAxis:Vector3D):Boolean
		{
			vec3.crossProdAxisZ(selfAxis, axis);
			axis.normalize();
			return getProjectLen(axis) + other.getProjectLen(axis) > absDot(ab, axis);
		}
		*/
	}
}