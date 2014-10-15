package snjdck.g3d.geom
{
	import flash.geom.Vector3D;
	
	import vec3.crossProd;
	import vec3.dotProd;
	import vec3.subtract;

	public class Plane3D
	{
		private const normal:Vector3D = new Vector3D();
		private var distance:Number;
		
		public function Plane3D(){}
		
		public function distanceToPoint(pt:Vector3D):Number
		{
			return vec3.dotProd(pt, normal) - distance;
		}
		
		/** 点在平面上的投影点 */
		public function project(pt:Vector3D, result:Vector3D):void
		{
			var d:Number = distanceToPoint(pt);
			result.x = pt.x - normal.x * d;
			result.y = pt.y - normal.y * d;
			result.z = pt.z - normal.z * d;
		}
		
		public function mirror(pt:Vector3D, result:Vector3D):void
		{
			var d:Number = distanceToPoint(pt) * 2;
			result.x = pt.x - normal.x * d;
			result.y = pt.y - normal.y * d;
			result.z = pt.z - normal.z * d;
		}
		
		public function setTo(a:Number, b:Number, c:Number, d:Number):void
		{
			normal.setTo(a, b, c);
			var factor:Number = 1 / normal.length;
			normal.scaleBy(factor);
			distance = d * factor;
		}
		
		public function fromPoints(p0:Vector3D, p1:Vector3D, p2:Vector3D):void
		{
			vec3.subtract(p1, p0, tempPointAB);
			vec3.subtract(p2, p0, tempPointAC);
			vec3.crossProd(tempPointAB, tempPointAC, normal);
			normal.normalize();
			distance = dotProd(normal, p0);
		}
		
		public function fromNormalAndPoint(theNormal:Vector3D, point:Vector3D):void
		{
			normal.copyFrom(theNormal);
			normal.normalize();
			distance = dotProd(normal, point);
		}
		
		static private const tempPointAB:Vector3D = new Vector3D();
		static private const tempPointAC:Vector3D = new Vector3D();
	}
}