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
		
		
		public function get pivotX():Number
		{
			return _pivotX;
		}
		
		public function set pivotX(value:Number):void
		{
			_pivotX = value;
			isDirty = true;
		}
		
		public function get pivotY():Number
		{
			return _pivotY;
		}
		
		public function set pivotY(value:Number):void
		{
			_pivotY = value;
			isDirty = true;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
			isDirty = true;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
			isDirty = true;
		}
		
		public function get scaleX():Number
		{
			return _scaleX;
		}
		
		public function set scaleX(value:Number):void
		{
			_scaleX = value;
			isDirty = true;
		}
		
		public function get scaleY():Number
		{
			return _scaleY;
		}
		
		public function set scaleY(value:Number):void
		{
			_scaleY = value;
			isDirty = true;
		}
		
		public function set scale(value:Number):void
		{
			_scaleX = _scaleY = value;
			isDirty = true;
		}
		
		public function get rotation():Number
		{
			return _rotation;
		}
		
		public function set rotation(value:Number):void
		{
			_rotation = value;
			isDirty = true;
		}
	}
}