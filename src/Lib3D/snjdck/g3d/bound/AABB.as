package snjdck.g3d.bound
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.pickup.Ray;

	public class AABB implements IBoundingBox
	{
		internal var center:Vector3D;
		private var halfSize:Vector3D;
//		public var radius:Number;
		
		public function AABB()
		{
			center = new Vector3D();
			halfSize = new Vector3D();
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
		
		public function setCenterAndSize(center:Vector3D, size:Vector3D):void
		{
			this.center.copyFrom(center);
			halfSize = size;
			halfSize.scaleBy(0.5);
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
	}
}