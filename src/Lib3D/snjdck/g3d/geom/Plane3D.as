package snjdck.g3d.geom
{
	import flash.geom.Vector3D;
	
	import vec3.crossProd;
	import vec3.dotProd;
	import vec3.subtract;

	/**
	 * ax + by + cz + d = 0
	 */
	public class Plane3D
	{
		public var a:Number;
		public var b:Number;
		public var c:Number;
		public var d:Number;
		
		public function Plane3D(){}
		
		public function setTo(va:Number, vb:Number, vc:Number, vd:Number):void
		{
			this.a = va;
			this.b = vb;
			this.c = vc;
			this.d = vd;
		}
		
		public function distance(pt:Vector3D):Number
		{
			return a * pt.x + b * pt.y + c * pt.z + d;
		}
		
		/** 点在平面上的投影点 */
		public function project(pt:Vector3D, result:Vector3D):void
		{
			tempNormal.setTo(a, b, c);
			tempNormal.normalize();
			var d:Number = distance(pt);
			tempNormal.scaleBy(d);
			vec3.subtract(pt, tempNormal, result);
		}
		
		public function mirror(pt:Vector3D, result:Vector3D):void
		{
			tempNormal.setTo(a, b, c);
			tempNormal.normalize();
			var d:Number = distance(pt);
			tempNormal.scaleBy(d * 2);
			vec3.subtract(pt, tempNormal, result);
		}
		
		public function normalize():void
		{
			var factor:Number = 1 / Math.sqrt(a*a + b*b + c*c);
			a *= factor;
			b *= factor;
			c *= factor;
			d *= factor;
		}
		
		public function fromPoints(p0:Vector3D, p1:Vector3D, p2:Vector3D):void
		{
			vec3.subtract(p1, p0, tempPointAB);
			vec3.subtract(p2, p0, tempPointAC);
			vec3.crossProd(tempPointAB, tempPointAC, tempNormal);
			fromNormalAndPoint(tempNormal, p0);
		}
		
		public function fromNormalAndPoint(normal:Vector3D, point:Vector3D):void
		{
			this.a = normal.x;
			this.b = normal.y;
			this.c = normal.z;
			this.d = -dotProd(normal, point);
		}
		
		static private const tempPointAB:Vector3D = new Vector3D();
		static private const tempPointAC:Vector3D = new Vector3D();
		static private const tempNormal:Vector3D = new Vector3D();
	}
}