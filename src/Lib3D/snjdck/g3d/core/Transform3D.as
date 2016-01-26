package snjdck.g3d.core
{
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import matrix33.decompose;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.geom.Matrix4x4;
	
	use namespace ns_g3d;
	
	internal class Transform3D
	{
		private const _transform:Matrix4x4 = new Matrix4x4();
		private const eulerAngles:Vector3D = new Vector3D();
		
		private var isWorldMatrixDirty:Boolean;
		private var isLocalMatrixDirty:Boolean;
		private const worldMatrix:Matrix3D = new Matrix3D();
		private const localMatrix:Matrix3D = new Matrix3D();
		
		public function Transform3D(){}
		
		public function isVisible():Boolean
		{
			var _scale:Vector3D = _transform.scale;
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
				_transform.rotation.fromEulerAngles(eulerAngles.x, eulerAngles.y, eulerAngles.z);
				_transform.toMatrix(localMatrix);
				isLocalMatrixDirty = false;
			}
			return localMatrix;
		}
		
		public function set transform(value:Matrix3D):void
		{
			markWorldMatrixDirty();
			if(localMatrix != value)
				localMatrix.copyFrom(value);
			isLocalMatrixDirty = false;
		}
		
		private function markLocalMatrixDirty():void
		{
			if(isLocalMatrixDirty)
				return;
			isLocalMatrixDirty = true;
			onLocalMatrixDirty();
		}
		
		final ns_g3d function markWorldMatrixDirty():void
		{
			if(isWorldMatrixDirty)
				return;
			isWorldMatrixDirty = true;
			onWorldMatrixDirty();
		}
		
		virtual protected function onLocalMatrixDirty():void{}
		virtual protected function onWorldMatrixDirty():void{}
		
		public function get x():Number
		{
			return _transform.translation.x;
		}
		
		public function set x(value:Number):void
		{
			if(x == value)
				return;
			_transform.translation.x = value;
			onTransformChanged();
		}
		
		public function get y():Number
		{
			return _transform.translation.y;
		}
		
		public function set y(value:Number):void
		{
			if(y == value)
				return;
			_transform.translation.y = value;
			onTransformChanged();
		}
		
		public function get z():Number
		{
			return _transform.translation.z;
		}
		
		public function set z(value:Number):void
		{
			if(z == value)
				return;
			_transform.translation.z = value;
			onTransformChanged();
		}
		
		public function set scale(val:Number):void
		{
			var _scale:Vector3D = _transform.scale;
			if(scaleX == val && scaleY == val && scaleZ == val)
				return;
			_scale.x = _scale.y = _scale.z = val;
			onTransformChanged();
		}
		
		public function get scaleX():Number
		{
			return _transform.scale.x;
		}
		
		public function set scaleX(value:Number):void
		{
			if(scaleX == value)
				return;
			_transform.scale.x = value;
			onTransformChanged();
		}
		
		public function get scaleY():Number
		{
			return _transform.scale.y;
		}
		
		public function set scaleY(value:Number):void
		{
			if(scaleY == value)
				return;
			_transform.scale.y = value;
			onTransformChanged();
		}
		
		public function get scaleZ():Number
		{
			return _transform.scale.z;
		}
		
		public function set scaleZ(value:Number):void
		{
			if(scaleZ == value)
				return;
			_transform.scale.z = value;
			onTransformChanged();
		}
		
		public function get rotationX():Number
		{
			return eulerAngles.x;
		}
		
		public function set rotationX(value:Number):void
		{
			if(rotationX == value)
				return;
			eulerAngles.x = value;
			onTransformChanged();
		}
		
		public function get rotationY():Number
		{
			return eulerAngles.y;
		}
		
		public function set rotationY(value:Number):void
		{
			if(rotationY == value)
				return;
			eulerAngles.y = value;
			onTransformChanged();
		}
		
		public function get rotationZ():Number
		{
			return eulerAngles.z;
		}
		
		public function set rotationZ(value:Number):void
		{
			if(rotationZ == value)
				return;
			eulerAngles.z = value;
			onTransformChanged();
		}
		
		private function onTransformChanged():void
		{
			markLocalMatrixDirty();
			markWorldMatrixDirty();
		}
		/*
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
		*/
		public function syncMatrix2D(matrix2d:Matrix):void
		{
			matrix33.decompose(matrix2d, _transform.translation, _transform.scale, eulerAngles);
			onTransformChanged();
		}
	}
}