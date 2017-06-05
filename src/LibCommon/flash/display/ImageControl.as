package flash.display
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.DisplayUtil;
	import flash.utils.ShapeUtil;
	
	import snjdck.editor.codegen.ItemData;
	import snjdck.editor.codegen.PropKeys;
	
	public class ImageControl extends Sprite
	{
		static private const size:Number = 10;
		static private const color:uint = 0xFF0000;
		
		private var _target:DisplayObject;
		
		private var moveBtn:Sprite;
		
		private var top:Sprite;
		private var left:Sprite;
		private var right:Sprite;
		private var bottom:Sprite;
		
		private var topLeft:Sprite;
		private var topRight:Sprite;
		private var bottomLeft:Sprite;
		private var bottomRight:Sprite;
		
		private var currentControl:Sprite;
		
		private var mouseStageX:Number;
		private var mouseStageY:Number;
		
		private var oldTopLeftX:Number;
		private var oldTopLeftY:Number;
		
		private var oldBottomRightX:Number;
		private var oldBottomRightY:Number;
		
		public function ImageControl()
		{
			init();
		}
		
		public function getTarget():DisplayObject
		{
			return _target;
		}
		
		public function setTarget(target:DisplayObject):void
		{
			if(_target == target){
				return;
			}
			
			visible = target != null;
			
			_target = target;
			
			if(_target != null){
				updateSelf();
				onMouseDown(this);
			}
		}
		
		private function updateSelf():void
		{
			onResize(_target.x, _target.y, _target.x + _target.width, _target.y + _target.height);
		}
		
		private function isCenterXDefined():Boolean
		{
			return !isNaN(_target["centerX"]);
		}
		
		private function isCenterYDefined():Boolean
		{
			return !isNaN(_target["centerY"]);
		}
		
		private function isLeftDefined():Boolean
		{
			return !isNaN(_target["left"]);
		}
		
		private function isRightDefined():Boolean
		{
			return !isNaN(_target["right"]);
		}
		
		private function isTopDefined():Boolean
		{
			return !isNaN(_target["top"]);
		}
		
		private function isBottomDefined():Boolean
		{
			return !isNaN(_target["bottom"]);
		}
		
		private function init():void
		{
			moveBtn = ShapeUtil.CreateCircle(size, color);
			
			top = ShapeUtil.CreateCircle(size, color);
			left = ShapeUtil.CreateCircle(size, color);
			right = ShapeUtil.CreateCircle(size, color);
			bottom = ShapeUtil.CreateCircle(size, color);
			
			topLeft = ShapeUtil.CreateCircle(size, color);
			topRight = ShapeUtil.CreateCircle(size, color);
			bottomLeft = ShapeUtil.CreateCircle(size, color);
			bottomRight = ShapeUtil.CreateCircle(size, color);
			
			visible = false;
			DisplayUtil.AddChildren(this, [moveBtn, top, bottom, left, right, topLeft, topRight, bottomLeft, bottomRight]);
			
			addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
		}
		
		private function __onMouseDown(evt:MouseEvent):void
		{
			onMouseDown(evt.target as Sprite);
		}
		
		private function onMouseDown(target:Sprite):void
		{
			mouseChildren = false;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
			
			currentControl = target;
			
			mouseStageX = stage.mouseX;
			mouseStageY = stage.mouseY;
			
			oldTopLeftX = topLeft.x;
			oldTopLeftY = topLeft.y;
			
			oldBottomRightX = bottomRight.x;
			oldBottomRightY = bottomRight.y;
		}
		
		private function __onMouseUp(evt:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
			mouseChildren = true;
		}
		
		private function __onMouseMove(evt:MouseEvent):void
		{
			var offsetX:Number = evt.stageX - mouseStageX;
			var offsetY:Number = evt.stageY - mouseStageY;
			
			switch(currentControl)
			{
				case topLeft:
					if(isCenterXDefined() && isCenterYDefined()){
						onTopLeftMove(offsetX, offsetY, true, true);
					}else if(isCenterXDefined()){
						if(!isTopDefined()){
							onTopLeftMove(offsetX, offsetY, true, false);
						}
					}else if(isCenterYDefined()){
						if(!isLeftDefined()){
							onTopLeftMove(offsetX, offsetY, false, true);
						}
					}else if(!(isLeftDefined() || isTopDefined())){
						onTopLeftMove(offsetX, offsetY);
					}
					break;
				case topRight:
					if(isCenterXDefined() && isCenterYDefined()){
						onTopRightMove(offsetX, offsetY, true, true);
					}else if(isCenterXDefined()){
						if(!isTopDefined()){
							onTopRightMove(offsetX, offsetY, true, false);
						}
					}else if(isCenterYDefined()){
						if(!isRightDefined()){
							onTopRightMove(offsetX, offsetY, false, true);
						}
					}else if(!(isRightDefined() || isTopDefined())){
						onTopRightMove(offsetX, offsetY);
					}
					break;
				case bottomLeft:
					if(isCenterXDefined() && isCenterYDefined()){
						onBottomLeftMove(offsetX, offsetY, true, true);
					}else if(isCenterXDefined()){
						if(!isBottomDefined()){
							onBottomLeftMove(offsetX, offsetY, true, false);
						}
					}else if(isCenterYDefined()){
						if(!isLeftDefined()){
							onBottomLeftMove(offsetX, offsetY, false, true);
						}
					}else if(!(isLeftDefined() || isBottomDefined())){
						onBottomLeftMove(offsetX, offsetY);
					}
					break;
				case bottomRight:
					if(isCenterXDefined() && isCenterYDefined()){
						onBottomRightMove(offsetX, offsetY, true, true);
					}else if(isCenterXDefined()){
						if(!isBottomDefined()){
							onBottomRightMove(offsetX, offsetY, true, false);
						}
					}else if(isCenterYDefined()){
						if(!isRightDefined()){
							onBottomRightMove(offsetX, offsetY, false, true);
						}
					}else if(!(isRightDefined() || isBottomDefined())){
						onBottomRightMove(offsetX, offsetY);
					}
					break;
				case top:
					if(isCenterYDefined()){
						doResize(0, offsetY, 0, -offsetY);
					}else if(!isTopDefined()){
						doResize(0, offsetY, 0, 0);
					}
					break;
				case bottom:
					if(isCenterYDefined()){
						doResize(0, -offsetY, 0, offsetY);
					}else if(!isBottomDefined()){
						doResize(0, 0, 0, offsetY);
					}
					break;
				case left:
					if(isCenterXDefined()){
						doResize(offsetX, 0, -offsetX, 0);
					}else if(!isLeftDefined()){
						doResize(offsetX, 0, 0, 0);
					}
					break;
				case right:
					if(isCenterXDefined()){
						doResize(-offsetX, 0, offsetX, 0);
					}else if(!isRightDefined()){
						doResize(0, 0, offsetX, 0);
					}
					break;
				case moveBtn:
				case this:
					if(isCenterXDefined() || isLeftDefined() || isRightDefined()){
						offsetX = 0;
					}
					if(isCenterYDefined() || isTopDefined() || isBottomDefined()){
						offsetY = 0;
					}
					doResize(offsetX, offsetY, offsetX, offsetY);
					break;
			}
		}
		
		private function doResize(offsetTopLeftX:Number, offsetTopLeftY:Number, offsetBottomRightX:Number, offsetBottomRightY:Number):void
		{
			if(offsetTopLeftX == 0 && offsetTopLeftY == 0 && offsetBottomRightX == 0 && offsetBottomRightY == 0){
				return;
			}
			onResize(oldTopLeftX+offsetTopLeftX, oldTopLeftY+offsetTopLeftY, oldBottomRightX+offsetBottomRightX, oldBottomRightY+offsetBottomRightY);
		}
		
		private function onResize(topLeftX:Number, topLeftY:Number, bottomRightX:Number, bottomRightY:Number):void
		{
			topLeft.x = topLeftX;
			topLeft.y = topLeftY;
			
			topRight.x = bottomRightX;
			topRight.y = topLeftY;
			
			bottomLeft.x = topLeftX;
			bottomLeft.y = bottomRightY;
			
			bottomRight.x = bottomRightX;
			bottomRight.y = bottomRightY;
			
			const newWidth:Number = bottomRightX - topLeftX;
			const newHeight:Number = bottomRightY - topLeftY;
			const centerX:Number = topLeftX + 0.5 * newWidth;
			const centerY:Number = topLeftY + 0.5 * newHeight;
			
			top.x = centerX;
			top.y = topLeftY;
			
			bottom.x = centerX;
			bottom.y = bottomRightY;
			
			left.x = topLeftX;
			left.y = centerY;
			
			right.x = bottomRightX;
			right.y = centerY;
			
			moveBtn.x = centerX;
			moveBtn.y = topLeftY - 30;
			
			_target.x = topLeftX;
			_target.y = topLeftY;
			_target.width = newWidth;
			_target.height = newHeight;
			dispatchEvent(new Event(Event.CHANGE));
			
			graphics.clear();
			graphics.lineStyle(0, 0xFF0000);
			graphics.beginFill(0, 0);
			graphics.drawRect(topLeftX, topLeftY, newWidth, newHeight);
			graphics.endFill();
		}
		
		private function onTopLeftMove(offsetX:Number, offsetY:Number, flagX:Boolean=false, flagY:Boolean=false):void
		{
			const imageWidth:Number = oldBottomRightX - oldTopLeftX;
			const imageHeight:Number = oldBottomRightY - oldTopLeftY;
			
			const newScaleX:Number = - offsetX / imageWidth;
			const newScaleY:Number = - offsetY / imageHeight;
			
			if(newScaleX < newScaleY){
				offsetX = - newScaleY * imageWidth;
			}else{
				offsetY = - newScaleX * imageHeight;
			}
			
			doResize(offsetX, offsetY, (flagX ? -offsetX : 0), (flagY ? -offsetY : 0));
		}
		
		private function onTopRightMove(offsetX:Number, offsetY:Number, flagX:Boolean=false, flagY:Boolean=false):void
		{
			const imageWidth:Number = oldBottomRightX - oldTopLeftX;
			const imageHeight:Number = oldBottomRightY - oldTopLeftY;
			
			const newScaleX:Number =   offsetX / imageWidth;
			const newScaleY:Number = - offsetY / imageHeight;
			
			if(newScaleX < newScaleY){
				offsetX =   newScaleY * imageWidth;
			}else{
				offsetY = - newScaleX * imageHeight;
			}
			
			doResize((flagX ? -offsetX : 0), offsetY, offsetX, (flagY ? -offsetY : 0));
		}
		
		private function onBottomLeftMove(offsetX:Number, offsetY:Number, flagX:Boolean=false, flagY:Boolean=false):void
		{
			const imageWidth:Number = oldBottomRightX - oldTopLeftX;
			const imageHeight:Number = oldBottomRightY - oldTopLeftY;
			
			const newScaleX:Number = - offsetX / imageWidth;
			const newScaleY:Number =   offsetY / imageHeight;
			
			if(newScaleX < newScaleY){
				offsetX = - newScaleY * imageWidth;
			}else{
				offsetY =   newScaleX * imageHeight;
			}
			
			doResize(offsetX, (flagY ? -offsetY : 0), (flagX ? -offsetX : 0), offsetY);
		}
		
		private function onBottomRightMove(offsetX:Number, offsetY:Number, flagX:Boolean=false, flagY:Boolean=false):void
		{
			const imageWidth:Number = oldBottomRightX - oldTopLeftX;
			const imageHeight:Number = oldBottomRightY - oldTopLeftY;
			
			const newScaleX:Number = offsetX / imageWidth;
			const newScaleY:Number = offsetY / imageHeight;
			
			if(newScaleX < newScaleY){
				offsetX = newScaleY * imageWidth;
			}else{
				offsetY = newScaleX * imageHeight;
			}
			
			doResize((flagX ? -offsetX : 0), (flagY ? -offsetY : 0), offsetX, offsetY);
		}
		
		public function setTargetProp(key:String, value:*):void
		{
			ItemData.setKey(_target, key, value);
			if(PropKeys.sizeName.indexOf(key) >= 0){
				$.nextFrameDo(updateSelf);
			}
		}
	}
}