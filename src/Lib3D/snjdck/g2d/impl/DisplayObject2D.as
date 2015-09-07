package snjdck.g2d.impl
{
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.signals.SignalGroup;
	
	import matrix33.transformCoords;
	import matrix33.transformCoordsInv;
	
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.core.IFilter2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.IScene;
	import snjdck.gpu.asset.GpuContext;
	
	import stdlib.constant.Unit;
	
	use namespace ns_g2d;

	public class DisplayObject2D extends SignalGroup
	{
		public var name:String;
		
		private var _x:Number, _scaleX:Number, _pivotX:Number;
		private var _y:Number, _scaleY:Number, _pivotY:Number;
		private var _rotation:Number;
		protected var _width:Number, _height:Number;
		
		public var mouseEnabled:Boolean = true;
		public var mouseX:Number, mouseY:Number;
		
		public var visible:Boolean = true;
		public var filter:IFilter2D;
		
		private var _parent:DisplayObjectContainer2D;
		ns_g2d var _scene:IScene;
		ns_g2d var _root:DisplayObjectContainer2D;
		
		private var isLocalMatrixDirty:Boolean;
		private const _localMatrix:Matrix = new Matrix();
		
		ns_g2d const prevWorldMatrix:Matrix = new Matrix();
		
		/** 防止递归操作 */
		private var isLocked:Boolean;
		
		private var _clipRect:ClipRect;
		public var clipContent:Boolean;
		
		public function DisplayObject2D()
		{
			_clipRect = new ClipRect(prevWorldMatrix);
			
			_pivotX = _pivotY = 0;
			_x = _y = 0;
			_scaleX = _scaleY = 1;
			_rotation = 0;
			_width = _height = 0;
		}
		
		/** 1.缩放, 2.旋转, 3.位移 */
		private function calcTransform():void
		{
			_localMatrix.identity();
			if(_pivotX != 0 || _pivotY != 0){
				_localMatrix.translate(_pivotX, _pivotY);
			}
			_localMatrix.scale(_scaleX, _scaleY);
			_localMatrix.rotate(_rotation * Unit.RADIAN);
			_localMatrix.translate(_x, _y);
		}
		
		public function get transform():Matrix
		{
			if(isLocalMatrixDirty){
				calcTransform();
				isLocalMatrixDirty = false;
			}
			return _localMatrix;
		}
		
		public function updateMouseXY(parentMouseX:Number, parentMouseY:Number):void
		{
			transformCoordsInv(transform, parentMouseX, parentMouseY, tempPt);
			mouseX = tempPt.x;
			mouseY = tempPt.y;
		}
		
		public function onUpdate(timeElapsed:int):void
		{
			if(!hasVisibleArea()){
				return;
			}
			if(isDraging){
				x = parent.mouseX - dragOffsetX;
				y = parent.mouseY - dragOffsetY;
			}
			prevWorldMatrix.copyFrom(transform);
			if(parent != null){
				prevWorldMatrix.concat(parent.prevWorldMatrix);
			}
			notify(Event.ENTER_FRAME, this);
		}
		
		ns_g2d function collectOpaqueArea(collector:OpaqueAreaCollector):void{}
		ns_g2d function draw(render2d:Render2D, context3d:GpuContext):void
		{
			if(clipContent){
				_clipRect.drawBegin(render2d, context3d);
				onDraw(render2d, context3d);
				_clipRect.drawEnd(render2d, context3d);
			}else{
				onDraw(render2d, context3d);
			}
		}
		
		virtual protected function onDraw(render2d:Render2D, context3d:GpuContext):void{}
		
		public function findTargetUnderMouse():DisplayObject2D
		{
			return containsPt(mouseX, mouseY) ? this : null;
		}
		
		public function containsPt(localX:Number, localY:Number):Boolean
		{
			if(clipContent && !clipRect.contains(localX, localY)){
				return false;
			}
			return (0 <= localX) && (localX < width) && (0 <= localY) && (localY < height);
		}
		
		public function isMouseOver():Boolean
		{
			return containsPt(mouseX, mouseY);
		}
		
		final public function removeFromParent():void
		{
			if(parent != null){
				parent.removeChild(this);
			}
		}
		
		public function globalToLocal(globalX:Number, globalY:Number, output:Point):void
		{
			transformCoordsInv(prevWorldMatrix, globalX, globalY, output);
		}
		
		public function globalToLocal2(globalPt:Point, output:Point):void
		{
			globalToLocal(globalPt.x, globalPt.y, output);
		}
		
		public function localToGlobal(localX:Number, localY:Number, output:Point):void
		{
			transformCoords(prevWorldMatrix, localX, localY, output);
		}
		
		public function localToGlobal2(localPt:Point, output:Point):void
		{
			localToGlobal(localPt.x, localPt.y, output);
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
			
			if(parent != null){
				parent.removeChild(this);
			}
			
			_parent = value;
			
			if(parent != null){
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
			mouseX += _x - value;
			_x = value;
			isLocalMatrixDirty = true;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			mouseY += _y - value;
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
		
		public function set scale(value:Number):void
		{
			_scaleX = _scaleY = value;
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
		
		public function get scaleWidth():Number
		{
			return _scaleX * _width;
		}
		
		public function get scaleHeight():Number
		{
			return _scaleY * _height;
		}
		
		public function get clipRect():Rectangle
		{
			return _clipRect;
		}
		
		public function hasVisibleArea():Boolean
		{
			return visible && (scaleX != 0) && (scaleY != 0);
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
		static protected const tempPt:Point = new Point();
		static private const tempRect:Rectangle = new Rectangle();
		
		public function swapToTop():void
		{
			parent.swapChildToTop(this);
		}
		
		public function swapToBottom():void
		{
			parent.swapChildToBottom(this);
		}
		
		final public function get scene():IScene
		{
			var target:DisplayObject2D = this;
			for(;;){
				if(target._scene != null){
					return target._scene;
				}
				if(null == target._parent){
					return null;
				}
				target = target._parent;
			}
			return null;
		}
		
		final public function get root():DisplayObjectContainer2D
		{
			var target:DisplayObject2D = this;
			for(;;){
				if(target._root != null){
					return target._root;
				}
				if(null == target._parent){
					return null;
				}
				target = target._parent;
			}
			return null;
		}
		
		public function findParent(parentName:String):DisplayObjectContainer2D
		{
			var target:DisplayObjectContainer2D = parent;
			while(target != null){
				if(target.name == parentName){
					return target;
				}
				target = target.parent;
			}
			return null;
		}
		
		private var isDraging:Boolean;
		private var dragOffsetX:Number;
		private var dragOffsetY:Number;
		
		public function startDrag():void
		{
			dragOffsetX = mouseX;
			dragOffsetY = mouseY;
			isDraging = true;
		}
		
		public function stopDrag():void
		{
			isDraging = false;
		}
	}
}