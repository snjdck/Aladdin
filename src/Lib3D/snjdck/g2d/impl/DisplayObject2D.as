package snjdck.g2d.impl
{
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import matrix33.compose;
	import matrix33.prependTranslation;
	import matrix33.transformCoords;
	
	import snjdck.g2d.core.IFilter2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.asset.GpuContext;
	
	import stdlib.constant.Unit;

	public class DisplayObject2D
	{
		private var _x:Number, _scaleX:Number, _pivotX:Number;
		private var _y:Number, _scaleY:Number, _pivotY:Number;
		private var _rotation:Number;
		protected var _width:Number, _height:Number;
		
		public var mouseEnabled:Boolean;
		
		public var alpha:Number = 1;
		private var _colorTransform:ColorTransform;
		
		public var visible:Boolean = true;
		public var filter:IFilter2D;
		
		private var _parent:DisplayObjectContainer2D;
		
		private var isLocalMatrixDirty:Boolean;
		private const _localMatrix:Matrix = new Matrix();
		
		/** 防止递归操作 */
		private var isLocked:Boolean;
		
		public function DisplayObject2D()
		{
			_pivotX = _pivotY = 0;
			_x = _y = 0;
			_scaleX = _scaleY = 1;
			_rotation = 0;
			_width = _height = 0;
			_colorTransform = new ColorTransform();
		}
		
		/** 1.缩放, 2.旋转, 3.位移 */
		private function calcTransform():void
		{
			compose(_localMatrix, _scaleX, _scaleY, _rotation * Unit.RADIAN, _x, _y);
			if(0 == _pivotX && 0 == _pivotY) return;
			prependTranslation(_localMatrix, -_pivotX, -_pivotY);
		}
		
		public function get transform():Matrix
		{
			if(isLocalMatrixDirty){
				calcTransform();
				isLocalMatrixDirty = false;
			}
			return _localMatrix;
		}
		
		virtual public function onUpdate(timeElapsed:int):void{}
		virtual public function draw(render:Render2D, context3d:GpuContext):void{}
		
		virtual public function pickup(px:Number, py:Number):DisplayObject2D
		{
			if(false == visible){
				return null;
			}
			
			getRect(this, tempRect);
			if(tempRect.contains(px, py)){
				return this;
			}
			
			return null;
		}
		
		final public function removeFromParent():void
		{
			if(parent){
				parent.removeChild(this);
			}
		}
		
		public function globalToLocal(point:Point):Point
		{
			return null;
		}
		
		public function localToGlobal(point:Point):Point
		{
			return null;
		}
		
		final public function get parent():DisplayObjectContainer2D
		{
			return _parent;
		}
		
		public function set parent(value:DisplayObjectContainer2D):void
		{
			if(isLocked || parent == value){
				return;
			}
			
			isLocked = true;
			
			if(parent){
				parent.removeChild(this);
			}
			
			_parent = value;
			
			if(parent){
				parent.addChild(this);
			}
			
			isLocked = false;
		}
		
		public function get pivotX():Number
		{
			return _pivotX;
		}

		public function set pivotX(value:Number):void
		{
			_pivotX = value;
			isLocalMatrixDirty = true;
		}

		public function get pivotY():Number
		{
			return _pivotY;
		}

		public function set pivotY(value:Number):void
		{
			_pivotY = value;
			isLocalMatrixDirty = true;
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
			isLocalMatrixDirty = true;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
			isLocalMatrixDirty = true;
		}

		public function get scaleX():Number
		{
			return _scaleX;
		}

		public function set scaleX(value:Number):void
		{
			_scaleX = value;
			isLocalMatrixDirty = true;
		}

		public function get scaleY():Number
		{
			return _scaleY;
		}

		public function set scaleY(value:Number):void
		{
			_scaleY = value;
			isLocalMatrixDirty = true;
		}

		public function get rotation():Number
		{
			return _rotation;
		}

		public function set rotation(value:Number):void
		{
			_rotation = value;
			isLocalMatrixDirty = true;
		}
		
		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			_width = value;
		}
		
		public function get height():Number
		{
			return _height;
		}

		public function set height(value:Number):void
		{
			_height = value;
		}
		
		public function get colorTransform():ColorTransform
		{
			return _colorTransform;
		}
		
		public function hasVisibleArea():Boolean
		{
			return visible && (alpha > 0) && (scaleX != 0) && (scaleY != 0);
		}
		
		public function getBounds(targetSpace:DisplayObject2D, result:Rectangle):void
		{
			getRect(targetSpace, result);
			if(filter != null){
				result.inflate(filter.marginX, filter.marginY);
			}
		}
		
		public function getRect(targetSpace:DisplayObject2D, result:Rectangle):void
		{
			calcSpaceTransform(targetSpace, tempMatrix1);
			
			var minX:Number = Number.MAX_VALUE, maxX:Number = Number.MIN_VALUE;
			var minY:Number = Number.MAX_VALUE, maxY:Number = Number.MIN_VALUE;
			
			transformCoords(tempMatrix1, 0, 0, tempPt);
			if(tempPt.x < minX){ minX = tempPt.x; }
			if(tempPt.y < minY){ minY = tempPt.y; }
			if(tempPt.x > maxX){ maxX = tempPt.x; }
			if(tempPt.y > maxY){ maxY = tempPt.y; }
			transformCoords(tempMatrix1, width, 0, tempPt);
			if(tempPt.x < minX){ minX = tempPt.x; }
			if(tempPt.y < minY){ minY = tempPt.y; }
			if(tempPt.x > maxX){ maxX = tempPt.x; }
			if(tempPt.y > maxY){ maxY = tempPt.y; }
			transformCoords(tempMatrix1, width, height, tempPt);
			if(tempPt.x < minX){ minX = tempPt.x; }
			if(tempPt.y < minY){ minY = tempPt.y; }
			if(tempPt.x > maxX){ maxX = tempPt.x; }
			if(tempPt.y > maxY){ maxY = tempPt.y; }
			transformCoords(tempMatrix1, 0, height, tempPt);
			if(tempPt.x < minX){ minX = tempPt.x; }
			if(tempPt.y < minY){ minY = tempPt.y; }
			if(tempPt.x > maxX){ maxX = tempPt.x; }
			if(tempPt.y > maxY){ maxY = tempPt.y; }
			
			result.setTo(minX, minY, maxX-minX, maxY-minY);
		}
		
		public function calcSpaceTransform(targetSpace:DisplayObject2D, result:Matrix):void
		{
			if(parent == targetSpace){
				result.copyFrom(transform);
				return;
			}
			result.identity();
			var target:DisplayObject2D = this;
			while(target != null){
				if(target == targetSpace){
					return;
				}
				result.concat(target.transform);
				target = target.parent;
			}
			if(null == targetSpace){
				return;
			}
			targetSpace.calcWorldMatrix(tempMatrix2);
			tempMatrix2.invert();
			result.concat(tempMatrix2);
		}
		
		public function calcWorldMatrix(result:Matrix):void
		{
			result.identity();
			var target:DisplayObject2D = this;
			while(target != null){
				result.concat(target.transform);
				target = target.parent;
			}
		}
		
		static private const tempMatrix1:Matrix = new Matrix();
		static private const tempMatrix2:Matrix = new Matrix();
		static private const tempPt:Point = new Point();
		static private const tempRect:Rectangle = new Rectangle();
	}
}