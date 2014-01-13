package ui.core
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.xmlui.UIPanel;

	public class Component extends UIPanel
	{
		private var _bg:DisplayObject;
		private const view:Sprite = new Sprite();
		private var _fg:DisplayObject;
		
		private var isWidthSet:Boolean;
		
		private var isHeightSet:Boolean;
		
		private var _clipContent:Boolean;
		private var clipRect:Rectangle;
		
		public function Component()
		{
			$_addChild(view);
			createChildren();
			initDefaultUI();
		}
		
		protected function createChildren():void
		{
		}
		
		protected function initDefaultUI():void
		{
		}
		
		public function dispose():void
		{
			
		}
		
		override public function get width():Number
		{
			return isWidthSet ? super.width : view.width;
		}
		
		override public function get height():Number
		{
			return isHeightSet ? super.height : view.height;
		}
		
		override public function set width(value:Number):void
		{
			isWidthSet = true;
			super.width = value;
		}
		
		override public function set height(value:Number):void
		{
			isHeightSet = true;
			super.height = value;
		}
		
		override public function onResize():void
		{
			super.onResize();
			updateClipRect();
		}
		
		public function set backgroundColor(color:uint):void
		{
			var g:Graphics = graphics;
			
			g.clear();
			g.beginFill(color & 0xFFFFFF, (color >>> 24) / 0xFF);
			g.drawRect(0, 0, width, height);
			g.endFill();
		}
		
		public function get backgroundChild():DisplayObject
		{
			return _bg;
		}
		
		public function set backgroundChild(child:DisplayObject):void
		{
			if(backgroundChild == child){
				return;
			}
			if(backgroundChild){
				$_removeChild(backgroundChild);
			}
			_bg = child;
			if(backgroundChild){
				$_addChildAt(backgroundChild, 0);
			}
		}
		
		public function get foregroundChild():DisplayObject
		{
			return _fg;
		}
		
		public function set foregroundChild(child:DisplayObject):void
		{
			if(foregroundChild == child){
				return;
			}
			if(foregroundChild){
				$_removeChild(foregroundChild);
			}
			_fg = child;
			if(foregroundChild){
				$_addChild(foregroundChild);
			}
		}
		
		final public function $_addChild(child:DisplayObject):DisplayObject
		{
			return super.addChild(child);
		}
		
		final public function $_addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return super.addChildAt(child, index);
		}
		
		final public function $_contains(child:DisplayObject):Boolean
		{
			return super.contains(child);
		}
		
		final public function $_getChildAt(index:int):DisplayObject
		{
			return super.getChildAt(index);
		}
		
		final public function $_getChildByName(name:String):DisplayObject
		{
			return super.getChildByName(name);
		}
		
		final public function $_getChildIndex(child:DisplayObject):int
		{
			return super.getChildIndex(child);
		}
		
		final public function $_getObjectsUnderPoint(point:Point):Array
		{
			return super.getObjectsUnderPoint(point);
		}
		
		final public function $_removeChild(child:DisplayObject):DisplayObject
		{
			return super.removeChild(child);
		}
		
		final public function $_removeChildAt(index:int):DisplayObject
		{
			return super.removeChildAt(index);
		}
		
		final public function $_setChildIndex(child:DisplayObject, index:int):void
		{
			super.setChildIndex(child, index);
		}
		
		final public function $_swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			super.swapChildren(child1, child2);
		}
		
		final public function $_swapChildrenAt(index1:int, index2:int):void
		{
			super.swapChildrenAt(index1, index2);
		}
		
		override public function get numChildren():int
		{
			return view.numChildren;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return view.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return view.addChildAt(child, index);
		}
		
		override public function contains(child:DisplayObject):Boolean
		{
			return view.contains(child);
		}
		
		override public function getChildAt(index:int):DisplayObject
		{
			return index >= 0 ? view.getChildAt(index) : null;
		}
		
		override public function getChildByName(name:String):DisplayObject
		{
			return view.getChildByName(name);
		}
		
		override public function getChildIndex(child:DisplayObject):int
		{
			return view == child.parent ? view.getChildIndex(child) : -1;
		}
		
		override public function getObjectsUnderPoint(point:Point):Array
		{
			return view.getObjectsUnderPoint(point);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			return view.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			return view.removeChildAt(index);
		}
		
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			if( child.parent != view || index < 0 )
				return;
			view.setChildIndex(child, index);
		}
		
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			if( child1.parent != view || child2.parent != view )
				return;
			view.swapChildren(child1, child2);
		}
		
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			if( index1<0 || index2<0 || index1>view.numChildren-1 || index2>view.numChildren-1 )
				return;
			view.swapChildrenAt(index1, index2);
		}
		
		public function get contentX():Number
		{
			return view.x;
		}
		
		public function set contentX(value:Number):void
		{
			view.x = value;
		}
		
		public function get contentY():Number
		{
			return view.y;
		}
		
		public function set contentY(value:Number):void
		{
			view.y = value;
		}
		
		public function get contentWidth():Number
		{
			return view.width;
		}
		
		public function get contentHeight():Number
		{
			return view.height;
		}

		public function get clipContent():Boolean
		{
			return _clipContent;
		}

		public function set clipContent(value:Boolean):void
		{
			if(clipContent == value){
				return;
			}
			_clipContent = value;
			if(clipContent){
				if(null == clipRect){
					clipRect = new Rectangle();
				}
				updateClipRect();
			}
			super.scrollRect = clipContent ? clipRect : null;
		}
		
		private function updateClipRect():void
		{
			if(clipRect){
				clipRect.width = width;
				clipRect.height = height;
			}
		}
	}
}