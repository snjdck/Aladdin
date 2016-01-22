package snjdck.g2d.impl
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.signals.ISignalGroup;
	import flash.signals.SignalGroup;
	
	import matrix33.transformCoords;
	
	import snjdck.g2d.Scene2D;
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.core.IFilter2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g2d;

	public class DisplayObject2D extends BoundTransform2D implements ISignalGroup
	{
		public var id:int;
		public var name:String;
		public var userData:*;
		
		private const signalGroup:SignalGroup = new SignalGroup();
		
		public var mouseEnabled:Boolean;
		
		private var isMouseMoved:Boolean;
		private var _mouseX:Number;
		private var _mouseY:Number;
		
		public var filter:IFilter2D;
		private var _visible:Boolean;
		
		private var _parent:DisplayObjectContainer2D;
		ns_g2d var _scene:Scene2D;
		ns_g2d var _root:DisplayObjectContainer2D;
		
		/** 防止递归操作 */
		private var isLocked:Boolean;
		
		private var _clipRect:ClipRect;
		public var clipContent:Boolean;
		
		public function DisplayObject2D()
		{
			_clipRect = new ClipRect(this);
			mouseEnabled = true;
			_visible = true;
		}
		
		override protected function getParent():Transform2D
		{
			return parent;
		}
		
		override protected function onWorldMatrixDirty():void
		{
			isMouseMoved = true;
		}
		
		ns_g2d function updateMouseXY(stageMouseX:Number, stageMouseY:Number):void
		{
			if(isDraging){
				parent.globalToLocal(stageMouseX - dragOffsetX, stageMouseY - dragOffsetY, tempPt);
				x = tempPt.x;
				y = tempPt.y;
			}else{
				isMouseMoved = true;
			}
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
		
		final public function removeFromParent():void
		{
			if(parent != null){
				parent.removeChild(this);
			}
		}
		
		public function globalToLocal(globalX:Number, globalY:Number, output:Point):void
		{
			transformCoords(worldTransformInvert, globalX, globalY, output);
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
			if(targetSpace == this){
				result.copyFrom(bound);
			}else{
				calculateRelativeBound(targetSpace, result);
			}
		}
		
		static protected const tempPt:Point = new Point();
		
		public function swapToTop():void
		{
			parent.swapChildToTop(this);
		}
		
		public function swapToBottom():void
		{
			parent.swapChildToBottom(this);
		}
		
		final public function get scene():Scene2D
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
		
		public function get visible():Boolean
		{
			return _visible;
		}
		
		public function set visible(value:Boolean):void
		{
			if(_visible == value)
				return;
			_visible = value;
			markParentBoundDirty();
		}
		
		protected var isDraging:Boolean;
		private var dragOffsetX:Number;
		private var dragOffsetY:Number;
		
		public function startDrag():void
		{
			var theScene:Scene2D = scene;
			parent.localToGlobal(x, y, tempPt);
			dragOffsetX = theScene._mouseX - tempPt.x;
			dragOffsetY = theScene._mouseY - tempPt.y;
			isDraging = true;
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
		
		private function calcuateMouseXY():void
		{
			if(isMouseMoved){
				var theScene:Scene2D = scene;
				globalToLocal(theScene._mouseX, theScene._mouseY, tempPt);
				_mouseX = tempPt.x;
				_mouseY = tempPt.y;
				isMouseMoved = false;
			}
		}

		public function get mouseX():Number
		{
			calcuateMouseXY();
			return _mouseX;
		}

		public function get mouseY():Number
		{
			calcuateMouseXY();
			return _mouseY;
		}
	}
}