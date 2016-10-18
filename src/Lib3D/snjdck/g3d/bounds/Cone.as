package snjdck.g3d.bounds
{
	import flash.geom.Vector3D;
	
	import stdlib.constant.Unit;
	
	import vec3.dotProd;
	import vec3.subtract;

	internal class Cone extends Sphere
	{
		public const axis:Vector3D = new Vector3D(0, 0, 1);
		public const vertex:Vector3D = new Vector3D();
		
		private var zFar:Number;
		private var zNear:Number;
		
		private var sinRecip:Number;
		private var sinSqr:Number;
		private var cosSqr:Number;
		
		public function Cone()
		{
		}
		
		public function init(fieldOfViewY:Number, aspectRatio:Number, zNear:Number, zFar:Number):void
		{
			var tan:Number = Math.tan(0.5 * fieldOfViewY * Unit.RADIAN);
			var factor:Number = tan * tan * (1 + aspectRatio * aspectRatio);
			
			var offset:Number = 0.5 * Math.max(0, (zFar - zNear) - (zFar + zNear) * factor);
			center.z = zFar - offset;
			radius = Math.sqrt(offset * offset + zFar * zFar * factor);
			
			var range:Number = Math.atan(Math.sqrt(factor));
			var sin:Number = Math.sin(range);
			sinRecip = 1 / sin;
			sinSqr = sin * sin;
			cosSqr = sinSqr / factor;
			
			this.zFar = zFar;
			this.zNear = zNear;
		}
		
		public function hitSphere(sphere:Sphere):Boolean
		{
			ab.copyFrom(axis);
			ab.scaleBy(sphere.radius * sinRecip);
			vec3.subtract(vertex, ab, ab);
			vec3.subtract(sphere.center, ab, ab);
			
			var e:Number = vec3.dotProd(axis, ab);
			if(e > 0 && e * e > dotProd(ab, ab) * cosSqr){
				vec3.subtract(sphere.center, vertex, ab);
				e = vec3.dotProd(axis, ab);
				if(e >= 0){
					return true;
				}
				var dsqr:Number = dotProd(ab, ab);
				return (e * e <= dsqr * sinSqr) || (dsqr < sphere.radiusSqr);
			}
			return false;
		}
	}
}