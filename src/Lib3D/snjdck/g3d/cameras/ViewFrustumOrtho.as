package snjdck.g3d.cameras
{
	import flash.geom.Vector3D;
	
	import snjdck.g3d.bounds.AABB;
	import snjdck.g3d.bounds.IBound;
	import snjdck.g3d.bounds.Sphere;

	internal class ViewFrustumOrtho implements IViewFrustum
	{
		static private const SQRT6:Number = Math.sqrt(6);
		
		public const center:Vector3D = new Vector3D();
		
		private var projectSizeX:Number;
		private var projectSizeY:Number;
		
		public function ViewFrustumOrtho(){}
		
		public function resize(width:Number, height:Number):void
		{
			projectSizeX = width  * Math.SQRT1_2;
			projectSizeY = height * Math.SQRT2;
		}
		
		public function classifyBox(aabb:AABB):int
		{
			var otherCenter:Vector3D = aabb._center;
			
			var fx:Number = center.x - otherCenter.x;
			var fy:Number = center.y - otherCenter.y;
			
			var tx:Number = aabb.halfSizeX + aabb.halfSizeY;
			var dx:Number = Math.abs(fx - fy) - projectSizeX;
			if (dx >= tx) return ClassifyResult.OUTSIDE;

			var fz:Number = center.z - otherCenter.z;
			var ty:Number = tx + aabb.halfSizeZ * SQRT6;
			var dy:Number = Math.abs(fx + fy - fz * SQRT6) - projectSizeY;
			if (dy >= ty) return ClassifyResult.OUTSIDE;

			return (-dx >= tx && -dy >= ty) ? ClassifyResult.CONTAINS : ClassifyResult.INTERSECT;
		}
		
		public function classify(bound:IBound):int
		{
			return bound.onClassify(this);
		}
		
		public function classifySphere(bound:Sphere):int
		{
			return 0;
		}
		
		public function hitTest(bound:IBound):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function hitTestBox(bound:AABB):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function hitTestSphere(bound:Sphere):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		
	}
}