package snjdck.g2d.impl
{
	import flash.geom.Matrix;
	
	import snjdck.g2d.ns_g2d;
	
	import stdlib.constant.Unit;
	
	use namespace ns_g2d;

	internal class Transform2D
	{
		private var _x:Number, _scaleX:Number, _pivotX:Number;
		private var _y:Number, _scaleY:Number, _pivotY:Number;
		private var _rotation:Number;
		
		private var isWorldMatrixDirty:Boolean;
		private var isLocalMatrixDirty:Boolean;
		private const worldMatrix:Matrix = new Matrix();
		private const localMatrix:Matrix = new Matrix();
		
		public function Transform2D()
		{
			_pivotX = _pivotY = 0;
			_x = _y = 0;
			_scaleX = _scaleY = 1;
			_rotation = 0;
		}
		
		public function isVisible():Boolean
		{
			return (_scaleX != 0) && (_scaleY != 0);
		}
		
		public function get worldTransform():Matrix
		{
			if(isWorldMatrixDirty){
				var parentWorldMatrix:Matrix = parentWorldTransform;
				worldMatrix.copyFrom(transform);
				if(parentWorldMatrix != null)
					worldMatrix.concat(parentWorldMatrix);
				isWorldMatrixDirty = false;
			}
			return worldMatrix;
		}
		
		virtual protected function get parentWorldTransform():Matrix
		{
			return null;
		}
		
		public function get transform():Matrix
		{
			if(isLocalMatrixDirty){
				calcTransform();
				isLocalMatrixDirty = false;
			}
			return localMatrix;
		}
		
		/** 1.缩放, 2.旋转, 3.位移 */
		private function calcTransform():void
		{
			localMatrix.identity();
			if(_pivotX != 0 || _pivotY != 0){
				localMatrix.translate(_pivotX, _pivotY);
			}
			localMatrix.scale(_scaleX, _scaleY);
			localMatrix.rotate(_rotation * Unit.RADIAN);
			localMatrix.translate(_x, _y);
		}
		
		virtual protected function markLocalMatrixDirty():void
		{
			isLocalMatrixDirty = true;
		}
		
		virtual ns_g2d function markWorldMatrixDirty():void
		{
			isWorldMatrixDirty = true;
		}
		
		public function get pivotX():Number
		{
			return _pivotX;
		}
		
		public function set pivotX(value:Number):void
		{
			if(_pivotX == value)
				return;
			_pivotX = value;
			markLocalMatrixDirty();
			markWorldMatrixDirty();
		}
		
		public function get pivotY():Number
		{
			return _pivotY;
		}
		
		public function set pivotY(value:Number):void
		{
			if(_pivotY == value)
				return;
			_pivotY = value;
			markLocalMatrixDirty();
			markWorldMatrixDirty();
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			if(_x == value)
				return;
			_x = value;
			markLocalMatrixDirty();
			markWorldMatrixDirty();
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			if(_y == value)
				return;
			_y = value;
			markLocalMatrixDirty();
			markWorldMatrixDirty();
		}
		
		public function get scaleX():Number
		{
			return _scaleX;
		}
		
		public function set scaleX(value:Number):void
		{
			if(_scaleX == value)
				return;
			_scaleX = value;
			markLocalMatrixDirty();
			markWorldMatrixDirty();
		}
		
		public function get scaleY():Number
		{
			return _scaleY;
		}
		
		public function set scaleY(value:Number):void
		{
			if(_scaleY == value)
				return;
			_scaleY = value;
			markLocalMatrixDirty();
			markWorldMatrixDirty();
		}
		
		public function set scale(value:Number):void
		{
			if(_scaleX == value && _scaleY == value)
				return;
			_scaleX = _scaleY = value;
			markLocalMatrixDirty();
			markWorldMatrixDirty();
		}
		
		public function get rotation():Number
		{
			return _rotation;
		}
		
		public function set rotation(value:Number):void
		{
			if(_rotation == value)
				return;
			_rotation = value;
			markLocalMatrixDirty();
			markWorldMatrixDirty();
		}
	}
}