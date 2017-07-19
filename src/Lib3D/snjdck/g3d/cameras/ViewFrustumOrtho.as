package snjdck.g3d.cameras
{
	import flash.geom.Vector3D;
	
	import snjdck.g3d.bounds.AABB;
	import snjdck.g3d.bounds.IBound;
	import snjdck.g3d.bounds.Sphere;

	public class ViewFrustumOrtho implements IViewFrustum
	{
		static private const SQRT6:Number = 2.449489742783178;
		
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
		
		public function hitTest(bound:IBound):Boolean
		{
			return bound.onHitTest(this);
		}
		
		public function hitTestBox(bound:AABB):Boolean
		{
			return classifyBox(bound) <= 0;
		}
	}
}