package snjdck.g2d.impl
{
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.signals.ISignalGroup;
	import flash.signals.SignalGroup;
	
	import matrix33.transformCoords;
	import matrix33.transformCoordsInv;
	
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.core.IFilter2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.IScene;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g2d;

	public class DisplayObject2D extends BoundTransform2D implements ISignalGroup
	{
		public var id:int;
		public var name:String;
		public var userData:*;
		
		private const signalGroup:SignalGroup = new SignalGroup();
		
		public var mouseEnabled:Boolean;
		public var mouseX:Number, mouseY:Number;
		
		public var filter:IFilter2D;
		
		private var _parent:DisplayObjectContainer2D;
		ns_g2d var _scene:IScene;
		ns_g2d var _root:DisplayObjectContainer2D;
		
		/** 防止递归操作 */
		private var isLocked:Boolean;
		
		private var _clipRect:ClipRect;
		public var clipContent:Boolean;
		
		public function DisplayObject2D()
		{
			_clipRect = new ClipRect(this);
			mouseEnabled = true;
		}
		
		override protected function getParent():Transform2D
		{
			return parent;
		}
		
		ns_g2d function updateMouseXY(parentMouseX:Number, parentMouseY:Number):void
		{
			if(isDraging){
				x = parentMouseX - dragOffsetX;
				y = parentMouseY - dragOffsetY;
			}
			transformCoordsInv(transform, parentMouseX, parentMouseY, tempPt);
			mouseX = tempPt.x;
			mouseY = tempPt.y;
		}
		
		public function onUpdate(timeElapsed:int):void
		{
			notify(Event.ENTER_FRAME, this);
		}
		
		ns_g2d function collectOpaqueArea(collector:OpaqueAreaCollector):void{}
		
		final ns_g2d function draw(render2d:Render2D, context3d:GpuContext):void
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
			transformCoordsInv(worldTransform, globalX, globalY, output);
		}
		
		public function globalToLocal2(globalPt:Point, output:Point):void
		{
			globalToLocal(globalPt.x, globalPt.y, output);
		}
		
		public function localToGlobal(localX:Number, localY:Number, output:Point):void
		{
			transformCoords(worldTransform, localX, localY, output);
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
		
		public function get width():Number
		{
			return originalBound.width;
		}

		public function set width(value:Number):void
		{
			useExplicitWidth = true;
			explicitWidth = value;
			if(originalBound.width == value)
				return;
			originalBound.width = value;
			markBoundDirty();
		}
		
		public function get height():Number
		{
			return originalBound.height;
		}
		
		public function set height(value:Number):void
		{
			useExplicitHeight = true;
			explicitHeight = value;
			if(originalBound.height == value)
				return;
			originalBound.height = value;
			markBoundDirty();
		}
		
		public function get scaleWidth():Number
		{
			return scaleX * width;
		}
		
		public function get scaleHeight():Number
		{
			return scaleY * height;
		}
		
		public function get clipRect():Rectangle
		{
			return _clipRect;
		}
		
		override public function isVisible():Boolean
		{
			return visible && super.isVisible();
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
			calculateRelativeTransform(targetSpace, tempMatrix1);
			
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
		
		static private const tempMatrix1:Matrix = new Matrix();
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
			isDraging = true;
			dragOffsetX = parent.mouseX - x;
			dragOffsetY = parent.mouseY - y;
		}
		
		public function stopDrag():void
		{
			isDraging = false;
		}
		
		public function addListener(evtName:String, handler:Function, once:Boolean=false):void
		{
			signalGroup.addListener(evtName, handler, once);
		}
		
		public function hasListener(evtName:String, handler:Function):Boolean
		{
			return signalGroup.hasListener(evtName, handler);
		}
		
		public function notify(evtName:String, arg:Object):void
		{
			signalGroup.notify(evtName, arg);
		}
		
		public function removeListener(evtName:String, handler:Function):void
		{
			signalGroup.removeListener(evtName, handler);
		}
	}
}