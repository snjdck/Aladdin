package snjdck.g3d.geom
{
	import flash.geom.Vector3D;
	
	import snjdck.g3d.pickup.Ray;

	public class AABB
	{
		private var center:Vector3D;
		private var halfSize:Vector3D;
		
		public function AABB()
		{
		}
		
		public function hitRay(ray:Ray):Boolean
		{
			return containsPt(ray.getPt((minX - ray.pos.x) / ray.dir.x))
				|| containsPt(ray.getPt((maxX - ray.pos.x) / ray.dir.x))
				|| containsPt(ray.getPt((minY - ray.pos.y) / ray.dir.y))
				|| containsPt(ray.getPt((maxY - ray.pos.y) / ray.dir.y))
				|| containsPt(ray.getPt((minZ - ray.pos.z) / ray.dir.z))
				|| containsPt(ray.getPt((maxZ - ray.pos.z) / ray.dir.z));
		}
		
		public function containsPt(pt:Vector3D):Boolean
		{
			return (minX <= pt.x) && (pt.x <= maxX)
				&& (minY <= pt.y) && (pt.y <= maxY)
				&& (minZ <= pt.z) && (pt.z <= maxZ);
		}
		
		public function hitTest(other:AABB):Boolean
		{
			return !((minX >= other.maxX) || (maxX <= other.minX)
				||   (minY >= other.maxY) || (maxY <= other.minY)
				||   (minZ >= other.maxZ) || (maxZ <= other.minZ));
		}
		
		[Inline]
		private function get minX():Number
		{
			return center.x - halfSize.x;
		}
		
		[Inline]
		private function get maxX():Number
		{
			return center.x + halfSize.x;
		}
		
		[Inline]
		private function get minY():Number
		{
			return center.y - halfSize.y;
		}
		
		[Inline]
		private function get maxY():Number
		{
			return center.y + halfSize.y;
		}
		
		[Inline]
		private function get minZ():Number
		{
			return center.z - halfSize.z;
		}
		
		[Inline]
		private function get maxZ():Number
		{
			return center.z + halfSize.z;
		}
	}
}