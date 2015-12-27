package snjdck.g2d.impl
{
	import flash.geom.Matrix;
	
	import stdlib.constant.Unit;

	public class Transform2D
	{
		private var _x:Number, _scaleX:Number, _pivotX:Number;
		private var _y:Number, _scaleY:Number, _pivotY:Number;
		private var _rotation:Number;
		
		private const _matrix:Matrix = new Matrix();
		private var isDirty:Boolean;
		
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
		
		public function get transform():Matrix
		{
			if(isDirty){
				calcTransform();
				isDirty = false;
			}
			return _matrix;
		}
		
		/** 1.缩放, 2.旋转, 3.位移 */
		private function calcTransform():void
		{
			_matrix.identity();
			if(_pivotX != 0 || _pivotY != 0){
				_matrix.translate(_pivotX, _pivotY);
			}
			_matrix.scale(_scaleX, _scaleY);
			_matrix.rotate(_rotation * Unit.RADIAN);
			_matrix.translate(_x, _y);
		}
		
		internal function markWorldMatrixDirty():void{}
		
		public function get pivotX():Number
		{
			return _pivotX;
		}
		
		public function set pivotX(value:Number):void
		{
			if(_pivotX == value)
				return;
			_pivotX = value;
			isDirty = true;
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
			isDirty = true;
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
			isDirty = true;
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
			isDirty = true;
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
			isDirty = true;
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
			isDirty = true;
			markWorldMatrixDirty();
		}
		
		public function set scale(value:Number):void
		{
			if(_scaleX == value && _scaleY == value)
				return;
			_scaleX = _scaleY = value;
			isDirty = true;
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
			isDirty = true;
			markWorldMatrixDirty();
		}
	}
}