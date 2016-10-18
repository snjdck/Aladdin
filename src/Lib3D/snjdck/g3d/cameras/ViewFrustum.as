package snjdck.g3d.cameras
{
	import flash.geom.Vector3D;
	
	import snjdck.g3d.bounds.AABB;
	import snjdck.g3d.bounds.IBound;
	import snjdck.g3d.bounds.Sphere;
	
	import vec3.subtract;

	public class ViewFrustum implements IViewFrustum
	{
		static private const SQRT3_2:Number = Math.sqrt(1.5);
		static private const SQRT8:Number = 2 * Math.SQRT2;
		static private const SQRT6:Number = 2 * SQRT3_2;
		
		public const center:Vector3D = new Vector3D();
		public const halfSize:Vector3D = new Vector3D();
		
		private const offset:Vector3D = new Vector3D();
		
		public function ViewFrustum(){}
		
		public function resize(width:Number, height:Number):void
		{
			halfSize.x = 0.5 * width;
			halfSize.y = 0.5 * height;
		}
		
		public function classifyBox(aabb:AABB):int
		{
			vec3.subtract(center, aabb.center, offset);
			var t0:Number = aabb.halfSize.x + aabb.halfSize.y;
			var t1:Number = halfSize.x * Math.SQRT2;
			var dx:Number = Math.abs(offset.x - offset.y) - t1;
			if(dx >= t0) return ClassifyResult.AWAY;
			var t2:Number = aabb.halfSize.z * SQRT6;
			var t3:Number = halfSize.y * SQRT8;
			var dy:Number = Math.abs(offset.x + offset.y - SQRT6 * offset.z) - t3;
			var t4:Number = t0 + t2;
			if(dy >= t4) return ClassifyResult.AWAY;
			if(-dx >= t0 && -dy >= t4) return ClassifyResult.CONTAINS;
			t0 = SQRT3_2 * offset.z;
			t1 = 0.5 * (t1 + t2 + t3);
			if(Math.abs(offset.y - t0) >= aabb.halfSize.y + t1) return ClassifyResult.AWAY;
			if(Math.abs(offset.x - t0) >= aabb.halfSize.x + t1) return ClassifyResult.AWAY;
			return ClassifyResult.INTERECT;
		}
		
		public function classify(bound:IBound):int
		{
			return bound.classify(this);
		}
		
		public function classifySphere(bound:Sphere):int
		{
			return 0;
		}
	}
}