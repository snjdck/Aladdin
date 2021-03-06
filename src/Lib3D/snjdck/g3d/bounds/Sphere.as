package snjdck.g3d.bounds
{
	import flash.geom.Vector3D;
	
	import snjdck.g3d.cameras.IViewFrustum;
	
	import vec3.subtract;

	public class Sphere implements IBound
	{
		static protected const ab:Vector3D = new Vector3D();
		public const center:Vector3D = new Vector3D();
		
		private var _radius:Number;
		private var _radiusSqr:Number;
		
		public function Sphere()
		{
		}

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
		
		public function hitTest(other:IBound):Boolean
		{
			return other.hitTestSphere(this);
		}
		
		public function hitTestSphere(other:Sphere):Boolean
		{
			vec3.subtract(other.center, center, ab);
			var totalRadius:Number = radius + other.radius;
			return ab.lengthSquared < totalRadius * totalRadius;
		}
		
		public function hitTestBox(other:AABB):Boolean
		{
			vec3.subtract(other._center, center, ab);
			var totalRadius:Number = radius + other.getProjectLen(ab);
			return ab.lengthSquared < totalRadius * totalRadius;
		}
		
		public function onClassify(viewFrusum:IViewFrustum):int
		{
			return viewFrusum.classifySphere(this);
		}
		
		public function onHitTest(viewFrusum:IViewFrustum):Boolean
		{
			return viewFrusum.hitTestSphere(this);
		}
	}
}