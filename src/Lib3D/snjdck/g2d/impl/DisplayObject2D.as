package snjdck.g2d.impl
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import matrix33.compose;
	import matrix33.prependTranslation;
	import matrix33.transformCoords;
	
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.core.IDisplayObjectContainer2D;
	import snjdck.g2d.support.VertexData;
	import snjdck.gpu.GpuRender;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.filter.FragmentFilter;

	public class DisplayObject2D implements IDisplayObject2D
	{
		private var _x:Number, _scaleX:Number, _pivotX:Number;
		private var _y:Number, _scaleY:Number, _pivotY:Number;
		private var _rotation:Number;
		protected var _width:Number, _height:Number;
		
		private var _color:uint;
		private var _alpha:Number;
		
		private var _visible:Boolean;
		private var _filter:FragmentFilter;
		
		private var _parent:IDisplayObjectContainer2D;
		
		private var isLocalMatrixDirty:Boolean;
		private const _localMatrix:Matrix = new Matrix();
		
		private const _worldMatrix:Matrix = new Matrix();
		private const _worldMatrixInvert:Matrix = new Matrix();
		private var _worldAlpha:Number = 1;
		
		/** 防止递归操作 */
		private var isLocked:Boolean;
		
		public function DisplayObject2D()
		{
			_pivotX = _pivotY = 0;
			_x = _y = 0;
			_scaleX = _scaleY = 1;
			_rotation = 0;
			_width = _height = 0;
			_color = 0xFFFFFF;
			_alpha = 1;
			_visible = true;
//			_blendMode = BlendMode.ALPHAL;
		}
		
		/** 1.缩放, 2.旋转, 3.位移 */
		private function calcTransform():void
		{
			compose(_localMatrix, _scaleX, _scaleY, _rotation, _x, _y);
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
		
		public function onUpdate(timeElapsed:int, parentWorldMatrix:Matrix, parentWorldAlpha:Number):void
		{
			_worldMatrix.copyFrom(transform);
			
			if(parentWorldMatrix){
				_worldMatrix.concat(parentWorldMatrix);
			}
			
			_worldAlpha = alpha * parentWorldAlpha;
		}
		/*
		private const topLeft		:Point = new Point();
		private const topRight		:Point = new Point();
		private const bottomLeft	:Point = new Point();
		private const bottomRight	:Point = new Point();
		*/
		private const tempPoint:Point = new Point();
		
		virtual public function draw(render:GpuRender, context3d:GpuContext):void
		{
		}
		
		virtual public function pickup(px:Number, py:Number):IDisplayObject2D
		{
			if(false == visible){
				return null;
			}
			
			_worldMatrixInvert.copyFrom(_worldMatrix);
			_worldMatrixInvert.invert();
			transformCoords(_worldMatrixInvert, px, py, tempPoint);
			
			if(tempPoint.x >= 0
				&& tempPoint.y >= 0
				&& tempPoint.x < width
				&& tempPoint.y < height
			){
				return this;
			}
			
			return null;
		}
		
		
		/*
		virtual public function collectDrawUnits(collector:Collector2D):void
		{
		}
		
		virtual public function collectPickUnits(collector:Collector2D, px:Number, py:Number):void
		{
			if(false == visible){
				return;
			}
			
			transformCoords(_worldMatrixInvert, px, py, tempPoint);
			
			if(tempPoint.x >= 0
			&& tempPoint.y >= 0
			&& tempPoint.x < width
			&& tempPoint.y < height
			){
				var pickUnit:DrawUnit2D = collector.getFreeDrawUnit();
				pickUnit.target = this;
				collector.addDrawUnit(pickUnit);
			}
		}
		*/
		virtual public function preDrawRenderTargets(context3d:GpuContext):void
		{
		}
		
		[Inline]
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
		
		final public function get parent():IDisplayObjectContainer2D
		{
			return _parent;
		}
		
		public function set parent(value:IDisplayObjectContainer2D):void
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
		
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			_color = value;
		}
		
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void
		{
			_alpha = value;
		}
		
		public function get visible():Boolean
		{
			return _visible;
		}
		
		public function set visible(value:Boolean):void
		{
			_visible = value;
		}
		/*
		public function get opaque():Boolean
		{
			return BlendMode.NORMAL == _blendMode;
		}
		
		public function set opaque(value:Boolean):void
		{
			_blendMode = value ? BlendMode.NORMAL : BlendMode.ALPHAL;
		}
		
		public function get blendMode():BlendMode
		{
			return _blendMode;
		}
		
		public function set blendMode(value:BlendMode):void
		{
			_blendMode = value;
		}
		//*/
		final public function get worldMatrix():Matrix
		{
			return _worldMatrix;
		}
		
		final public function get worldAlpha():Number
		{
			return _worldAlpha;
		}
		
		public function get filter():FragmentFilter
		{
			return _filter;
		}
		
		public function set filter(value:FragmentFilter):void
		{
			_filter = value;
		}
		
		public function hasVisibleArea():Boolean
		{
			return visible && (alpha > 0) && (scaleX != 0) && (scaleY != 0);
		}
		
		public function getBounds(targetSpace:IDisplayObject2D, result:Rectangle):void
		{
			vertexData.reset(0, 0, width, height);
			calcSpaceTransform(targetSpace, tempMatrix1);
			vertexData.getBounds(tempMatrix1, result);
		}
		
		public function calcSpaceTransform(targetSpace:IDisplayObject2D, result:Matrix):void
		{
			if(parent == targetSpace){
				result.copyFrom(transform);
				return;
			}
			result.identity();
			var target:IDisplayObject2D = this;
			while(target != null){
				if(target == targetSpace){
					return;
				}
				result.concat(target.transform);
				target = target.parent;
			}
			targetSpace.calcWorldMatrix(tempMatrix2);
			tempMatrix2.invert();
			result.concat(tempMatrix2);
		}
		
		public function calcWorldMatrix(result:Matrix):void
		{
			result.identity();
			var target:IDisplayObject2D = this;
			while(target != null){
				result.concat(target.transform);
				target = target.parent;
			}
		}
		
		static protected const vertexData:VertexData = new VertexData();
		static protected const tempMatrix1:Matrix = new Matrix();
		static protected const tempMatrix2:Matrix = new Matrix();
	}
}