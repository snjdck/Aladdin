package flash.display
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.DisplayUtil;
	import flash.utils.ShapeUtil;
	
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
		
		public function setTarget(target:DisplayObject):void
		{
			this._target = target;
			var rect:Rectangle = target.getRect(parent);
			onResize(rect.x, rect.y, rect.right, rect.bottom);
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
			
			DisplayUtil.AddChildren(this, [moveBtn, top, bottom, left, right, topLeft, topRight, bottomLeft, bottomRight]);
			
			addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
		}
		
		private function __onMouseDown(evt:MouseEvent):void
		{
			mouseChildren = false;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, __onMouseUp);

			currentControl = evt.target as Sprite;
			
			mouseStageX = evt.stageX;
			mouseStageY = evt.stageY;
			
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
			const offsetX:Number = evt.stageX - mouseStageX;
			const offsetY:Number = evt.stageY - mouseStageY;
			
			switch(currentControl)
			{
				case topLeft:
					onTopLeftMove(offsetX, offsetY);
					break;
				case topRight:
					onTopRightMove(offsetX, offsetY);
					break;
				case bottomLeft:
					onBottomLeftMove(offsetX, offsetY);
					break;
				case bottomRight:
					onBottomRightMove(offsetX, offsetY);
					break;
				case top:
					doResize(0, offsetY, 0, 0);
					break;
				case bottom:
					doResize(0, 0, 0, offsetY);
					break;
				case left:
					doResize(offsetX, 0, 0, 0);
					break;
				case right:
					doResize(0, 0, offsetX, 0);
					break;
				case moveBtn:
					doResize(offsetX, offsetY, offsetX, offsetY);
					break;
			}
		}
		
		private function doResize(offsetTopLeftX:Number, offsetTopLeftY:Number, offsetBottomRightX:Number, offsetBottomRightY:Number):void
		{
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
			
			var pt:Point = new Point(topLeftX, topLeftY);
			pt = _target.parent.globalToLocal(parent.localToGlobal(pt));
			
			_target.x = pt.x;
			_target.y = pt.y;
			_target.width = newWidth;
			_target.height = newHeight;
		}
		
		private function onTopLeftMove(offsetX:Number, offsetY:Number):void
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
			
			doResize(offsetX, offsetY, 0, 0);
		}
		
		private function onTopRightMove(offsetX:Number, offsetY:Number):void
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
			
			doResize(0, offsetY, offsetX, 0);
		}
		
		private function onBottomLeftMove(offsetX:Number, offsetY:Number):void
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
			
			doResize(offsetX, 0, 0, offsetY);
		}
		
		private function onBottomRightMove(offsetX:Number, offsetY:Number):void
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
			
			doResize(0, 0, offsetX, offsetY);
		}
	}
}