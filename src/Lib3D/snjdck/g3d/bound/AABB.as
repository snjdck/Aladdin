package snjdck.g3d.bound
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.pickup.Ray;
	
	use namespace ns_g3d;

	public class AABB extends Sphere
	{
		public const halfSize:Vector3D = new Vector3D();
		
		public function AABB()
		{
			radius = 0;
		}
		
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
			
			radius = halfSize.length;
		}
		
		public function setCenterAndSize($center:Vector3D, size:Vector3D):void
		{
			center.copyFrom($center);
			halfSize.copyFrom(size);
			halfSize.scaleBy(0.5);
			radius = halfSize.length;
		}
		
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
			var rawData:Vector.<Number> = matrix.rawData;
			var minX:Number = rawData[12], maxX:Number = minX;
			var minY:Number = rawData[13], maxY:Number = minY;
			var minZ:Number = rawData[14], maxZ:Number = minZ;
			var factor:Number;
			//=================================x
			factor = rawData[0];
			if(factor > 0){
				minX += factor * this.minX;
				maxX += factor * this.maxX;
			}else{
				minX += factor * this.maxX;
				maxX += factor * this.minX;
			}
			factor = rawData[4];
			if(factor > 0){
				minX += factor * this.minY;
				maxX += factor * this.maxY;
			}else{
				minX += factor * this.maxY;
				maxX += factor * this.minY;
			}
			factor = rawData[8];
			if(factor > 0){
				minX += factor * this.minZ;
				maxX += factor * this.maxZ;
			}else{
				minX += factor * this.maxZ;
				maxX += factor * this.minZ;
			}
			//=================================y
			factor = rawData[1];
			if(factor > 0){
				minY += factor * this.minX;
				maxY += factor * this.maxX;
			}else{
				minY += factor * this.maxX;
				maxY += factor * this.minX;
			}
			factor = rawData[5];
			if(factor > 0){
				minY += factor * this.minY;
				maxY += factor * this.maxY;
			}else{
				minY += factor * this.maxY;
				maxY += factor * this.minY;
			}
			factor = rawData[9];
			if(factor > 0){
				minY += factor * this.minZ;
				maxY += factor * this.maxZ;
			}else{
				minY += factor * this.maxZ;
				maxY += factor * this.minZ;
			}
			//=================================z
			factor = rawData[2];
			if(factor > 0){
				minZ += factor * this.minX;
				maxZ += factor * this.maxX;
			}else{
				minZ += factor * this.maxX;
				maxZ += factor * this.minX;
			}
			factor = rawData[6];
			if(factor > 0){
				minZ += factor * this.minY;
				maxZ += factor * this.maxY;
			}else{
				minZ += factor * this.maxY;
				maxZ += factor * this.minY;
			}
			factor = rawData[10];
			if(factor > 0){
				minZ += factor * this.minZ;
				maxZ += factor * this.maxZ;
			}else{
				minZ += factor * this.maxZ;
				maxZ += factor * this.minZ;
			}
			
			result.setMinMax(minX, minY, minZ, maxX, maxY, maxZ);
		}
		
		public function copyFrom(other:AABB):void
		{
			center.copyFrom(other.center);
			halfSize.copyFrom(other.halfSize);
			radius = other.radius;
		}
		
		public function merge(other:AABB):void
		{
			if(other.isEmpty()){
				return;
			}
			if(isEmpty()){
				copyFrom(other);
				return;
			}
			
			var minX:Number = this.minX < other.minX ? this.minX : other.minX;
			var minY:Number = this.minY < other.minY ? this.minY : other.minY;
			var minZ:Number = this.minZ < other.minZ ? this.minZ : other.minZ;
			
			var maxX:Number = this.maxX > other.maxX ? this.maxX : other.maxX;
			var maxY:Number = this.maxY > other.maxY ? this.maxY : other.maxY;
			var maxZ:Number = this.maxZ > other.maxZ ? this.maxZ : other.maxZ;
			
			setMinMax(minX, minY, minZ, maxX, maxY, maxZ);
		}
		
		public function mergeZ(other:AABB):void
		{
			var minZ:Number = this.minZ < other.minZ ? this.minZ : other.minZ;
			var maxZ:Number = this.maxZ > other.maxZ ? this.maxZ : other.maxZ;
			center.z = 0.5 * (minZ + maxZ);
			halfSize.z = 0.5 * (maxZ - minZ);
			radius = halfSize.length;
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