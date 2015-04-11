package snjdck.g3d.bound
{
	import flash.geom.Vector3D;
	
	import vec3.subtract;

	public class Sphere
	{
		public const center:Vector3D = new Vector3D();
		
		private var _radius:Number;
		private var _radiusSqr:Number;
		
		public function Sphere()
		{
		}
		
		public function hitTestSphere(other:Sphere):Boolean
		{
			vec3.subtract(other.center, center, ab);
			var totalRadius:Number = radius + other.radius;
			return ab.lengthSquared < totalRadius * totalRadius;
		}
		
		static private const ab:Vector3D = new Vector3D();

		public function set radius(value:Number):void
		{
			_radius = value;
			_radiusSqr = value * value;
		}

		public function get radius():Number
		{
			return _radius;
		}
		
		public function get radiusSqr():Number
		{
			return _radiusSqr;
		}
	}
}