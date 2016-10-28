package snjdck.g3d.bounds
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import bound3d.union;
	
	import matrix44.transformBound;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.cameras.IViewFrustum;
	import snjdck.g3d.pickup.Ray;
	
	use namespace ns_g3d;

	final public class AABB implements IBound
	{
		public const _center:Vector3D = new Vector3D();
		
		private var _halfSizeX:Number;
		private var _halfSizeY:Number;
		private var _halfSizeZ:Number;
		
		private var _minX:Number;
		private var _minY:Number;
		private var _minZ:Number;
		
		private var _maxX:Number;
		private var _maxY:Number;
		private var _maxZ:Number;
		
		public function AABB()
		{
			clear();
		}
		
		public function get halfSizeX():Number
		{
			return _halfSizeX;
		}
		
		public function get halfSizeY():Number
		{
			return _halfSizeY;
		}
		
		public function get halfSizeZ():Number
		{
			return _halfSizeZ;
		}
		
		public function clear():void
		{
			_center.setTo(0, 0, 0);
			_halfSizeX = _halfSizeY = _halfSizeZ = 0;
			_minX = _minY = _minZ = 0;
			_maxX = _maxY = _maxZ = 0;
		}
		
		public function setCenterAndHalfSize(cx:Number, cy:Number, cz:Number, sx:Number, sy:Number, sz:Number):void
		{
			_center.x = cx;
			_center.y = cy;
			_center.z = cz;
			
			_halfSizeX = sx;
			_halfSizeY = sy;
			_halfSizeZ = sz;
			
			_minX = cx - sx;
			_minY = cy - sy;
			_minZ = cz - sz;
			
			_maxX = cx + sx;
			_maxY = cy + sy;
			_maxZ = cz + sz;
		}
		
		public function setMinMax(minX:Number, minY:Number, minZ:Number, maxX:Number, maxY:Number, maxZ:Number):void
		{
			_center.x = 0.5 * (minX + maxX);
			_center.y = 0.5 * (minY + maxY);
			_center.z = 0.5 * (minZ + maxZ);
			
			_halfSizeX = 0.5 * (maxX - minX);
			_halfSizeY = 0.5 * (maxY - minY);
			_halfSizeZ = 0.5 * (maxZ - minZ);
			
			_minX = minX;
			_minY = minY;
			_minZ = minZ;
			
			_maxX = maxX;
			_maxY = maxY;
			_maxZ = maxZ;
		}
		
		public function hitRay(ray:Ray, hit:Vector3D):Boolean
		{
			return containsPt(ray.getPt((_minX - ray.pos.x) / ray.dir.x, hit))
				|| containsPt(ray.getPt((_maxX - ray.pos.x) / ray.dir.x, hit))
				|| containsPt(ray.getPt((_minY - ray.pos.y) / ray.dir.y, hit))
				|| containsPt(ray.getPt((_maxY - ray.pos.y) / ray.dir.y, hit))
				|| containsPt(ray.getPt((_minZ - ray.pos.z) / ray.dir.z, hit))
				|| containsPt(ray.getPt((_maxZ - ray.pos.z) / ray.dir.z, hit));
		}
		
		public function containsPt(pt:Vector3D):Boolean
		{
			return (_minX <= pt.x) && (pt.x <= _maxX)
				&& (_minY <= pt.y) && (pt.y <= _maxY)
				&& (_minZ <= pt.z) && (pt.z <= _maxZ);
		}
		
		public function get minX():Number
		{
			return _minX;
		}
		
		public function get maxX():Number
		{
			return _maxX;
		}
		
		public function get minY():Number
		{
			return _minY;
		}
		
		public function get maxY():Number
		{
			return _maxY;
		}
		
		public function get minZ():Number
		{
			return _minZ;
		}
		
		public function get maxZ():Number
		{
			return _maxZ;
		}
		
		public function getProjectLen(axis:Vector3D):Number
		{
			return _halfSizeX * Math.abs(axis.x) + _halfSizeY * Math.abs(axis.y) + _halfSizeZ * Math.abs(axis.z);
		}
		
		public function hitTestAxis(other:IBoundingBox, ab:Vector3D):Boolean
		{
			return (Math.abs(ab.x) - other.getProjectLen(Vector3D.X_AXIS) < _halfSizeX)
				&& (Math.abs(ab.y) - other.getProjectLen(Vector3D.Y_AXIS) < _halfSizeY)
				&& (Math.abs(ab.z) - other.getProjectLen(Vector3D.Z_AXIS) < _halfSizeZ);
		}
		
		public function transform(matrix:Matrix3D, result:AABB):void
		{
			transformBound(matrix, this, result);
		}
		
		public function copyFrom(other:AABB):void
		{
			_center.copyFrom(other._center);
			
			_halfSizeX = other._halfSizeX;
			_halfSizeY = other._halfSizeY;
			_halfSizeZ = other._halfSizeZ;
			
			_minX = other._minX;
			_minY = other._minY;
			_minZ = other._minZ;
			
			_maxX = other._maxX;
			_maxY = other._maxY;
			_maxZ = other._maxZ;
		}
		
		public function merge(other:AABB):void
		{
			union(this, other, this);
		}
		
		public function mergeZ(other:AABB):void
		{
			var needUpdate:Boolean = false;
			if(_minZ > other._minZ){
				_minZ = other._minZ;
				needUpdate = true;
			}
			if(_maxZ < other._maxZ){
				_maxZ = other._maxZ;
				needUpdate = true;
			}
			if(needUpdate){
				_center.z  = 0.5 * (_maxZ + _minZ);
				_halfSizeZ = 0.5 * (_maxZ - _minZ);
			}
		}
		
		public function isEmpty():Boolean
		{
			return _halfSizeX <= 0 || _halfSizeY <= 0 || _halfSizeZ <= 0;
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
		
		public function hitTest(other:IBound):Boolean
		{
			return other.hitTestBox(this);
		}
		
		public function hitTestSphere(other:Sphere):Boolean
		{
			return other.hitTestBox(this);
		}
		
		public function hitTestBox(other:AABB):Boolean
		{
			return !((minX >= other.maxX) || (maxX <= other.minX)
				||   (minY >= other.maxY) || (maxY <= other.minY)
				||   (minZ >= other.maxZ) || (maxZ <= other.minZ));
		}
		
		public function onClassify(viewFrusum:IViewFrustum):int
		{
			return viewFrusum.classifyBox(this);
		}
		
		public function onHitTest(viewFrusum:IViewFrustum):Boolean
		{
			return viewFrusum.hitTestBox(this);
		}
	}
}