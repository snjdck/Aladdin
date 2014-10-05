package snjdck.g2d.impl
{
	import flash.geom.Rectangle;
	
	import array.delAt;
	import array.insert;
	
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.asset.GpuContext;
	
	public class DisplayObjectContainer2D extends DisplayObject2D
	{
		private var _childList:Vector.<DisplayObject2D>;
		private var _mouseChildren:Boolean;
		
		/** 防止递归操作 */
		private var isLocked:Boolean;
		
		public function DisplayObjectContainer2D()
		{
			_childList = new <DisplayObject2D>[];
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
		
		public function addChild(child:DisplayObject2D):void
		{
			addChildAt(child, numChildren);
		}
		
		public function addChildAt(child:DisplayObject2D, index:int):void
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
		
		public function removeChild(child:DisplayObject2D):void
		{
			removeChildAt(getChildIndex(child));
		}
		
		public function removeChildAt(index:int):DisplayObject2D
		{
			if(isLocked || isIndexValid(index) == false){
				return null;
			}
			
			isLocked = true;
			
			var child:DisplayObject2D = array.delAt(_childList, index);
			child.parent = null;
			
			isLocked = false;
			
			return child;
		}
		
		public function getChildAt(index:int):DisplayObject2D
		{
			return isIndexValid(index) ? _childList[index] : null;
		}
		
		public function getChildIndex(child:DisplayObject2D):int
		{
			return _childList.indexOf(child);
		}
		
		public function setChildIndex(child:DisplayObject2D, index:int):void
		{
			var oldIndex:int = getChildIndex(child);
			if(-1 != oldIndex){
				array.delAt(_childList, oldIndex);
				array.insert(_childList, index, child);
			}
		}
		
		public function swapChildren(child1:DisplayObject2D, child2:DisplayObject2D):void
		{
			swapChildrenAt(getChildIndex(child1), getChildIndex(child2));
		}
		
		public function swapChildrenAt(index1:int, index2:int):void
		{
			if(index1 == index2){
				return;
			}
			
			var child1:DisplayObject2D = getChildAt(index1);
			var child2:DisplayObject2D = getChildAt(index2);
			
			if(child1 && child2){
				_childList[index1] = child2;
				_childList[index2] = child1;
			}
		}
		
		public function contains(child:DisplayObject2D):Boolean
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
		
		override public function draw(render:Render2D, context3d:GpuContext):void
		{
			if(_childList.length <= 0){
				return;
			}
			render.pushMatrix(transform);
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
			render.popMatrix();
		}
		
		override public function pickup(px:Number, py:Number):DisplayObject2D
		{
			if(!mouseChildren){
				return null;
			}
			for(var i:int=_childList.length-1; i>=0; --i){
				var child:DisplayObject2D = _childList[i];
				if(!(child.hasVisibleArea() && child.mouseEnabled)){
					continue;
				}
				var target:DisplayObject2D = child.pickup(px, py);
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
		
		override public function getRect(targetSpace:DisplayObject2D, result:Rectangle):void
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
		
		override public function getBounds(targetSpace:DisplayObject2D, result:Rectangle):void
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