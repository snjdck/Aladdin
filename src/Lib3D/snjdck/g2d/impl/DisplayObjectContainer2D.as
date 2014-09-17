package snjdck.g2d.impl
{
	import flash.geom.Rectangle;
	
	import array.delAt;
	import array.insert;
	
	import snjdck.g2d.core.IDisplayObject2D;
	import snjdck.g2d.core.IDisplayObjectContainer2D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.render.GpuRender;
	
	public class DisplayObjectContainer2D extends DisplayObject2D implements IDisplayObjectContainer2D
	{
		private var _childList:Vector.<IDisplayObject2D>;
		private var _mouseChildren:Boolean;
		
		/** 防止递归操作 */
		private var isLocked:Boolean;
		
		public function DisplayObjectContainer2D()
		{
			_childList = new <IDisplayObject2D>[];
			_mouseChildren = true;
		}
		
		public function get numChildren():int
		{
			return _childList.length;
		}
		
		public function get mouseChildren():Boolean
		{
			return _mouseChildren;
		}
		
		public function set mouseChildren(value:Boolean):void
		{
			_mouseChildren = value;
		}
		
		private function isIndexValid(index:int):Boolean
		{
			return index >= 0 && index < numChildren;
		}
		
		public function addChild(child:IDisplayObject2D):void
		{
			addChildAt(child, numChildren);
		}
		
		public function addChildAt(child:IDisplayObject2D, index:int):void
		{
			if(isLocked || index < 0 || numChildren < index){
				return;
			}
			
			child.removeFromParent();
			
			isLocked = true;
			
			array.insert(_childList, index, child);
			child.parent = this;
			
			isLocked = false;
		}
		
		public function removeChild(child:IDisplayObject2D):void
		{
			removeChildAt(getChildIndex(child));
		}
		
		public function removeChildAt(index:int):IDisplayObject2D
		{
			if(isLocked || isIndexValid(index) == false){
				return null;
			}
			
			isLocked = true;
			
			var child:IDisplayObject2D = array.delAt(_childList, index);
			child.parent = null;
			
			isLocked = false;
			
			return child;
		}
		
		public function getChildAt(index:int):IDisplayObject2D
		{
			return isIndexValid(index) ? _childList[index] : null;
		}
		
		public function getChildIndex(child:IDisplayObject2D):int
		{
			return _childList.indexOf(child);
		}
		
		public function setChildIndex(child:IDisplayObject2D, index:int):void
		{
			var oldIndex:int = getChildIndex(child);
			if(-1 != oldIndex){
				array.delAt(_childList, oldIndex);
				array.insert(_childList, index, child);
			}
		}
		
		public function swapChildren(child1:IDisplayObject2D, child2:IDisplayObject2D):void
		{
			swapChildrenAt(getChildIndex(child1), getChildIndex(child2));
		}
		
		public function swapChildrenAt(index1:int, index2:int):void
		{
			if(index1 == index2){
				return;
			}
			
			var child1:IDisplayObject2D = getChildAt(index1);
			var child2:IDisplayObject2D = getChildAt(index2);
			
			if(child1 && child2){
				_childList[index1] = child2;
				_childList[index2] = child1;
			}
		}
		
		public function contains(child:IDisplayObject2D):Boolean
		{
			while(child){
				if(child == this){
					return true;
				}else{
					child = child.parent;
				}
			}
			return false;
		}
		
		override public function draw(render:GpuRender, context3d:GpuContext):void
		{
			if(_childList.length <= 0){
				return;
			}
			render.r2d.pushMatrix(transform);
			for each(var child:DisplayObject2D in _childList){
				if(!child.hasVisibleArea()){
					continue;
				}
				if(child.filter != null){
					child.filter.draw(child, render, context3d);
				}else{
					child.draw(render, context3d);
				}
			}
			render.r2d.popMatrix();
		}
		
		override public function pickup(px:Number, py:Number):IDisplayObject2D
		{
			for each(var child:DisplayObject2D in _childList){
				var target:IDisplayObject2D = child.pickup(px, py);
				if(target != null){
					return target;
				}
			}
			return null;
		}
		
		override public function onUpdate(timeElapsed:int):void
		{
			for each(var child:DisplayObject2D in _childList){
				child.onUpdate(timeElapsed);
			}
		}
		
		override public function getRect(targetSpace:IDisplayObject2D, result:Rectangle):void
		{
			if(_childList.length <= 0){
				super.getRect(targetSpace, result);
				return;
			}
			var minX:Number = Number.MAX_VALUE, maxX:Number = Number.MIN_VALUE;
			var minY:Number = Number.MAX_VALUE, maxY:Number = Number.MIN_VALUE;
			for each(var child:DisplayObject2D in _childList){
				child.getRect(targetSpace, result);
				var left:Number = result.x;
				var top:Number = result.y;
				var right:Number = left + result.width;
				var bottom:Number = top + result.height;
				if(left < minX){ minX = left; }
				if(top < minY){ minY = top; }
				if(right > maxX){ maxX = right; }
				if(bottom > maxY){ maxY = bottom; }
			}
			result.setTo(minX, minY, maxX-minX, maxY-minY);
			if(filter != null){
				result.inflate(filter.marginX, filter.marginY);
			}
		}
		
		override public function getBounds(targetSpace:IDisplayObject2D, result:Rectangle):void
		{
			if(_childList.length <= 0){
				super.getBounds(targetSpace, result);
				return;
			}
			var minX:Number = Number.MAX_VALUE, maxX:Number = Number.MIN_VALUE;
			var minY:Number = Number.MAX_VALUE, maxY:Number = Number.MIN_VALUE;
			for each(var child:DisplayObject2D in _childList){
				child.getBounds(targetSpace, result);
				var left:Number = result.x;
				var top:Number = result.y;
				var right:Number = left + result.width;
				var bottom:Number = top + result.height;
				if(left < minX){ minX = left; }
				if(top < minY){ minY = top; }
				if(right > maxX){ maxX = right; }
				if(bottom > maxY){ maxY = bottom; }
			}
			result.setTo(minX, minY, maxX-minX, maxY-minY);
		}
	}
}