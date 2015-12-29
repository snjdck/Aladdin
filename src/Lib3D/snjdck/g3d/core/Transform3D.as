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
		
		private var isWorldMatrixDirty:Boolean;
		private var isLocalMatrixDirty:Boolean;
		private const worldMatrix:Matrix3D = new Matrix3D();
		private const localMatrix:Matrix3D = new Matrix3D();
		
		public function Transform3D(){}
		
		public function isVisible():Boolean
		{
			return (_scale.x != 0) && (_scale.y != 0) && (_scale.z != 0);
		}
		
		public function get worldTransform():Matrix3D
		{
			if(isWorldMatrixDirty){
				var parentWorldMatrix:Matrix3D = parentWorldTransform;
				worldMatrix.copyFrom(transform);
				if(parentWorldMatrix != null)
					worldMatrix.append(parentWorldMatrix);
				isWorldMatrixDirty = false;
			}
			return worldMatrix;
		}
		
		public function set worldTransform(value:Matrix3D):void
		{
			markWorldMatrixDirty();
			if(worldMatrix != value)
				worldMatrix.copyFrom(value);
			isWorldMatrixDirty = false;
		}
		
		virtual protected function get parentWorldTransform():Matrix3D
		{
			return null;
		}
		
		public function get transform():Matrix3D
		{
			if(isLocalMatrixDirty){
				localMatrix.recompose(_components);
				isLocalMatrixDirty = false;
			}
			return localMatrix;
		}
		
		virtual internal function markWorldMatrixDirty():void
		{
			isWorldMatrixDirty = true;
		}
		
		public function get x():Number
		{
			return _position.x;
		}
		
		public function set x(value:Number):void
		{
			if(x == value)
				return;
			_position.x = value;
			isLocalMatrixDirty = true;
			markWorldMatrixDirty();
		}
		
		public function get y():Number
		{
			return _position.y;
		}
		
		public function set y(value:Number):void
		{
			if(y == value)
				return;
			_position.y = value;
			isLocalMatrixDirty = true;
			markWorldMatrixDirty();
		}
		
		public function get z():Number
		{
			return _position.z;
		}
		
		public function set z(value:Number):void
		{
			if(z == value)
				return;
			_position.z = value;
			isLocalMatrixDirty = true;
			markWorldMatrixDirty();
		}
		
		public function set scale(val:Number):void
		{
			if(scaleX == val && scaleY == val && scaleZ == val)
				return;
			_scale.x = _scale.y = _scale.z = val;
			isLocalMatrixDirty = true;
			markWorldMatrixDirty();
		}
		
		public function get scaleX():Number
		{
			return _scale.x;
		}
		
		public function set scaleX(value:Number):void
		{
			if(scaleX == value)
				return;
			_scale.x = value;
			isLocalMatrixDirty = true;
			markWorldMatrixDirty();
		}
		
		public function get scaleY():Number
		{
			return _scale.y;
		}
		
		public function set scaleY(value:Number):void
		{
			if(scaleY == value)
				return;
			_scale.y = value;
			isLocalMatrixDirty = true;
			markWorldMatrixDirty();
		}
		
		public function get scaleZ():Number
		{
			return _scale.z;
		}
		
		public function set scaleZ(value:Number):void
		{
			if(scaleZ == value)
				return;
			_scale.z = value;
			isLocalMatrixDirty = true;
			markWorldMatrixDirty();
		}
		
		public function get rotationX():Number
		{
			return _rotation.x;
		}
		
		public function set rotationX(value:Number):void
		{
			if(rotationX == value)
				return;
			_rotation.x = value;
			isLocalMatrixDirty = true;
			markWorldMatrixDirty();
		}
		
		public function get rotationY():Number
		{
			return _rotation.y;
		}
		
		public function set rotationY(value:Number):void
		{
			if(rotationY == value)
				return;
			_rotation.y = value;
			isLocalMatrixDirty = true;
			markWorldMatrixDirty();
		}
		
		public function get rotationZ():Number
		{
			return _rotation.z;
		}
		
		public function set rotationZ(value:Number):void
		{
			if(rotationZ == value)
				return;
			_rotation.z = value;
			isLocalMatrixDirty = true;
			markWorldMatrixDirty();
		}
		
		static private const tempPoint:Vector3D = new Vector3D();
		
		public function translateLocal(axis:Vector3D, distance:Number):void
		{
			var size:Number = distance / axis.length;
			
			localMatrix.prependTranslation(axis.x * size, axis.y * size, axis.z * size);
			localMatrix.copyColumnTo(3, tempPoint);
			_position.x = tempPoint.x;
			_position.y = tempPoint.y;
			_position.z = tempPoint.z;
		}
		
		public function syncMatrix2D(matrix2d:Matrix):void
		{
			matrix33.decompose(matrix2d, _position, _scale, _rotation);
			isLocalMatrixDirty = true;
			markWorldMatrixDirty();
		}
	}
}