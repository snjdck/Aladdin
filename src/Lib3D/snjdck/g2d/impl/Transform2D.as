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
		
		private var isWorldMatrixInvertDirty:Boolean;
		private var isLocalMatrixInvertDirty:Boolean;
		private const worldMatrixInvert:Matrix = new Matrix();
		private const localMatrixInvert:Matrix = new Matrix();
		
		public function Transform2D()
		{
			_pivotX = _pivotY = 0;
			_x = _y = 0;
			_scaleX = _scaleY = 1;
			_rotation = 0;
		}
		
		virtual protected function onLocalMatrixDirty():void{}
		virtual protected function onWorldMatrixDirty():void{}
		virtual protected function getParent():Transform2D{return null;}
		virtual protected function getChildren():Array{return null;}
		
		public function isVisible():Boolean
		{
			return (_scaleX != 0) && (_scaleY != 0);
		}
		
		public function get worldTransform():Matrix
		{
			if(isWorldMatrixDirty){
				var parent:Transform2D = getParent();
				worldMatrix.copyFrom(transform);
				if(parent != null)
					worldMatrix.concat(parent.worldTransform);
				isWorldMatrixDirty = false;
			}
			return worldMatrix;
		}
		
		/** 1.缩放, 2.旋转, 3.位移 */
		public function get transform():Matrix
		{
			if(isLocalMatrixDirty){
				localMatrix.identity();
				localMatrix.translate(_pivotX, _pivotY);
				localMatrix.scale(_scaleX, _scaleY);
				localMatrix.rotate(_rotation * Unit.RADIAN);
				localMatrix.translate(_x, _y);
				isLocalMatrixDirty = false;
			}
			return localMatrix;
		}
		
		public function get worldTransformInvert():Matrix
		{
			if(isWorldMatrixInvertDirty){
				worldMatrixInvert.copyFrom(worldTransform);
				worldMatrixInvert.invert();
				isWorldMatrixInvertDirty = false;
			}
			return worldMatrixInvert;
		}
		
		public function get transformInvert():Matrix
		{
			if(isLocalMatrixInvertDirty){
				localMatrixInvert.copyFrom(transform);
				localMatrixInvert.invert();
				isLocalMatrixInvertDirty = false;
			}
			return localMatrixInvert;
		}
		
		private function markLocalMatrixDirty():void
		{
			if(isLocalMatrixDirty)
				return;
			isLocalMatrixDirty = true;
			isLocalMatrixInvertDirty = true;
			onLocalMatrixDirty();
		}
		
		final internal function markWorldMatrixDirty():void
		{
			if(isWorldMatrixDirty)
				return;
			isWorldMatrixDirty = true;
			isWorldMatrixInvertDirty = true;
			onWorldMatrixDirty();
			var childList:Array = getChildren();
			for each(var child:Transform2D in childList){
				child.markWorldMatrixDirty();
			}
		}
		
		private function onTransformChanged():void
		{
			markLocalMatrixDirty();
			markWorldMatrixDirty();
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
			onTransformChanged();
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
			onTransformChanged();
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
			onTransformChanged();
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
			onTransformChanged();
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
			onTransformChanged();
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
			onTransformChanged();
		}
		
		public function set scale(value:Number):void
		{
			if(_scaleX == value && _scaleY == value)
				return;
			_scaleX = _scaleY = value;
			onTransformChanged();
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
			onTransformChanged();
		}
		
		protected function isDescendant(target:Transform2D):Boolean
		{
			while(target != null){
				if(target == this)
					return true;
				target = target.getParent();
			}
			return false;
		}
		
		protected function isAncestor(target:Transform2D):Boolean
		{
			if(target == null)
				return false;
			var node:Transform2D = this;
			do{
				if(node == target)
					return true;
				node = node.getParent();
			}while(node != null);
			return false;
		}
		
		public function calculateRelativeTransform(target:Transform2D, result:Matrix):void
		{
			if(target == null){
				result.copyFrom(worldTransform);
				return;
			}
			if(target == this){
				result.identity();
				return;
			}
			if(target == getParent()){
				result.copyFrom(transform);
				return;
			}
			if(target.getParent() == this){
				result.copyFrom(target.transformInvert);
				return;
			}
			if(isDescendant(target)){
				target.calculateRelativeTransform(this, result);
				result.invert();
				return;
			}
			if(isAncestor(target)){
				result.identity();
				var node:Transform2D = this;
				while(node != target){
					result.concat(node.transform);
					node = node.getParent();
				}
				return;
			}
			result.copyFrom(worldTransform);
			result.concat(target.worldTransformInvert);
		}
	}
}