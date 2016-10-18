package snjdck.g3d.bounds
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import bound3d.union;
	
	import matrix44.transformBound;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.pickup.Ray;
	
	use namespace ns_g3d;

	public class AABB
	{
		public const center:Vector3D = new Vector3D();
		public const halfSize:Vector3D = new Vector3D();
		
		public function AABB(){}
		
		public function clear():void
		{
			center.setTo(0, 0, 0);
			halfSize.setTo(0, 0, 0);
		}
		
		public function setMinMax(minX:Number, minY:Number, minZ:Number, maxX:Number, maxY:Number, maxZ:Number):void
		{
			center.x = 0.5 * (minX + maxX);
			center.y = 0.5 * (minY + maxY);
			center.z = 0.5 * (minZ + maxZ);
			
			halfSize.x = 0.5 * (maxX - minX);
			halfSize.y = 0.5 * (maxY - minY);
			halfSize.z = 0.5 * (maxZ - minZ);
		}
		/*
		public function setCenterAndSize($center:Vector3D, size:Vector3D):void
		{
			center.copyFrom($center);
			halfSize.copyFrom(size);
			halfSize.scaleBy(0.5);
		}
		*/
		public function hitRay(ray:Ray, hit:Vector3D):Boolean
		{
			return containsPt(ray.getPt((minX - ray.pos.x) / ray.dir.x, hit))
				|| containsPt(ray.getPt((maxX - ray.pos.x) / ray.dir.x, hit))
				|| containsPt(ray.getPt((minY - ray.pos.y) / ray.dir.y, hit))
				|| containsPt(ray.getPt((maxY - ray.pos.y) / ray.dir.y, hit))
				|| containsPt(ray.getPt((minZ - ray.pos.z) / ray.dir.z, hit))
				|| containsPt(ray.getPt((maxZ - ray.pos.z) / ray.dir.z, hit));
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
		public function get minX():Number
		{
			return center.x - halfSize.x;
		}
		
		[Inline]
		public function get maxX():Number
		{
			return center.x + halfSize.x;
		}
		
		[Inline]
		public function get minY():Number
		{
			return center.y - halfSize.y;
		}
		
		[Inline]
		public function get maxY():Number
		{
			return center.y + halfSize.y;
		}
		
		[Inline]
		public function get minZ():Number
		{
			return center.z - halfSize.z;
		}
		
		[Inline]
		public function get maxZ():Number
		{
			return center.z + halfSize.z;
		}
		/*
		public function getProjectLen(axis:Vector3D):Number
		{
			return halfSize.x * Math.abs(axis.x) + halfSize.y * Math.abs(axis.y) + halfSize.z * Math.abs(axis.z);
		}
		
		public function hitTestAxis(other:IBoundingBox, ab:Vector3D):Boolean
		{
			return (Math.abs(ab.x) - other.getProjectLen(Vector3D.X_AXIS) < halfSize.x)
				&& (Math.abs(ab.y) - other.getProjectLen(Vector3D.Y_AXIS) < halfSize.y)
				&& (Math.abs(ab.z) - other.getProjectLen(Vector3D.Z_AXIS) < halfSize.z);
		}
		*/
		//*
		public function transform(matrix:Matrix3D, result:AABB):void
		{
			transformBound(matrix, this, result);
		}
		
		public function copyFrom(other:AABB):void
		{
			center.copyFrom(other.center);
			halfSize.copyFrom(other.halfSize);
		}
		
		public function merge(other:AABB):void
		{
			union(this, other, this);
		}
		
		public function mergeZ(other:AABB):void
		{
			var minZ:Number = this.minZ < other.minZ ? this.minZ : other.minZ;
			var maxZ:Number = this.maxZ > other.maxZ ? this.maxZ : other.maxZ;
			center.z = 0.5 * (minZ + maxZ);
			halfSize.z = 0.5 * (maxZ - minZ);
		}
		
		public function isEmpty():Boolean
		{
			return halfSize.x <= 0 || halfSize.y <= 0 || halfSize.z <= 0;
		}
		
		public function contains(other:AABB):Boolean
		{
			if(this.minX > other.minX) return false;
			if(this.maxX < other.maxX) return false;
			if(this.minY > other.minY) return false;
			if(this.maxY < other.maxY) return false;
			if(this.minZ > other.minZ) return false;
			if(this.maxZ < other.maxZ) return false;
			return true;
		}
	}
}