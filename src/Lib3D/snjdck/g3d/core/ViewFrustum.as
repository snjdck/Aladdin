package snjdck.g3d.core
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import matrix44.extractPosition;
	
	import snjdck.g3d.bound.AABB;
	
	import vec3.subtract;

	public class ViewFrustum extends AABB
	{
		static public const CONTAINS:int = 1;
		static public const AWAY:int = 2;
		static public const INTERECT:int = 3;
		
		static private const SQRT8:Number = Math.SQRT2 * 2;
		static private const SQRT6:Number = Math.sqrt(6);
		
		private const offset:Vector3D = new Vector3D();
		
		public function ViewFrustum(){}
		
		public function resize(width:Number, height:Number):void
		{
			halfSize.x = 0.5 * width;
			halfSize.y = 0.5 * height;
		}
		
		public function updateAABB(cameraWorldMatrix:Matrix3D):void
		{
			matrix44.extractPosition(cameraWorldMatrix, center);
//			center.z =  center.y - center.x;
//			center.w = -center.y - center.x;
		}
		/*
		public function containsAABB(bound:AABB):Boolean
		{
			return hitTestRect(bound.center, bound.halfSize);
		}
		*/
		public function classify(aabb:AABB):int
		{
			vec3.subtract(center, aabb.center, offset);
			var t0:Number = aabb.halfSize.x + aabb.halfSize.y;
			var t1:Number = Math.SQRT2 * halfSize.x;
			var dx:Number = Math.abs(offset.x - offset.y) - t1;
			if( dx >= t0) return AWAY;
			var t2:Number = SQRT6 * aabb.halfSize.z + SQRT8 * halfSize.y;
			var t3:Number = SQRT6 * offset.z;
			var t4:Number = t0 + SQRT6 * aabb.halfSize.z;
			var dy:Number = Math.abs(offset.x + offset.y - t3) - SQRT8 * halfSize.y;
			if(dy >= t4) return AWAY;
			if(-dx >= t0 && -dy >= t4) return CONTAINS;
			t0 = 0.5 * t3;
			t1 = 0.5 * (t1 + t2);
			if(Math.abs(offset.y - t0) >= aabb.halfSize.y + t1) return AWAY;
			if(Math.abs(offset.x - t0) >= aabb.halfSize.x + t1) return AWAY;
			return INTERECT;
		}
	}
}