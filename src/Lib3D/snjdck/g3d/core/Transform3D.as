package snjdck.g3d.core
{
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import matrix33.decompose;
	
	public class Transform3D
	{
		private const _position:Vector3D = new Vector3D();
		private const _rotation:Vector3D = new Vector3D();
		private const _scale:Vector3D = new Vector3D(1, 1, 1);
		private const _components:Vector.<Vector3D> = new <Vector3D>[_position,_rotation,_scale];
		private const _matrix:Matrix3D = new Matrix3D();
		private var isDirty:Boolean;
		
		public function Transform3D(){}
		
		public function isVisible():Boolean
		{
			return (_scale.x != 0) && (_scale.y != 0) && (_scale.z != 0);
		}
		
		public function get transform():Matrix3D
		{
			if(isDirty){
				_matrix.recompose(_components);
				isDirty = false;
			}
			return _matrix;
		}
		
		public function get x():Number
		{
			return _position.x;
		}
		
		public function set x(value:Number):void
		{
			_position.x = value;
			isDirty = true;
		}
		
		public function get y():Number
		{
			return _position.y;
		}
		
		public function set y(value:Number):void
		{
			_position.y = value;
			isDirty = true;
		}
		
		public function get z():Number
		{
			return _position.z;
		}
		
		public function set z(value:Number):void
		{
			_position.z = value;
			isDirty = true;
		}
		
		public function set scale(val:Number):void
		{
			_scale.x = _scale.y = _scale.z = val;
			isDirty = true;
		}
		
		public function get scaleX():Number
		{
			return _scale.x;
		}
		
		public function set scaleX(value:Number):void
		{
			_scale.x = value;
			isDirty = true;
		}
		
		public function get scaleY():Number
		{
			return _scale.y;
		}
		
		public function set scaleY(value:Number):void
		{
			_scale.y = value;
			isDirty = true;
		}
		
		public function get scaleZ():Number
		{
			return _scale.z;
		}
		
		public function set scaleZ(value:Number):void
		{
			_scale.z = value;
			isDirty = true;
		}
		
		public function get rotationX():Number
		{
			return _rotation.x;
		}
		
		public function set rotationX(value:Number):void
		{
			_rotation.x = value;
			isDirty = true;
		}
		
		public function get rotationY():Number
		{
			return _rotation.y;
		}
		
		public function set rotationY(value:Number):void
		{
			_rotation.y = value;
			isDirty = true;
		}
		
		public function get rotationZ():Number
		{
			return _rotation.z;
		}
		
		public function set rotationZ(value:Number):void
		{
			_rotation.z = value;
			isDirty = true;
		}
		
		static private const tempPoint:Vector3D = new Vector3D();
		
		public function translateLocal(axis:Vector3D, distance:Number):void
		{
			var size:Number = distance / axis.length;
			
			_matrix.prependTranslation(axis.x * size, axis.y * size, axis.z * size);
			_matrix.copyColumnTo(3, tempPoint);
			_position.x = tempPoint.x;
			_position.y = tempPoint.y;
			_position.z = tempPoint.z;
		}
		
		public function syncMatrix2D(matrix2d:Matrix):void
		{
			matrix33.decompose(matrix2d, _position, _scale, _rotation);
			isDirty = true;
		}
	}
}