package snjdck.display.dnd
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import array.sub;
	
	import flash.display.InteractiveBitmap;
	
	import flash.bitmap.drawMC;

	final public class DragMgr
	{
		static private const dragImage:InteractiveBitmap = new InteractiveBitmap();
		static private var objectsUnderMouseLastTime:Array = [];
		static private var dragTarget:DisplayObject;
		static private var dropTarget:DisplayObject;
		static private var dragData:Object;
		
		static private function Reset():void
		{
			if(!(dragTarget is Bitmap)){
				dragImage.bitmapData.dispose();
			}
			dragImage.bitmapData = null;
			objectsUnderMouseLastTime.length = 0;
			dragTarget = null;
			dropTarget = null;
			dragData = null;
		}
		
		static public function acceptDrop(target:DisplayObject):void
		{
			dropTarget = target;
		}

		static public function doDrag(target:DisplayObject, extraData:Object=null):void
		{
			dragTarget = target;
			dragData = extraData;
			dragImage.bitmapData = dragTarget is Bitmap ? (dragTarget as Bitmap).bitmapData : drawMC(dragTarget);
			notifyEvt(dragTarget, DragDropEvent.DRAG_START);
			beginDrag();
		}
		
		static private function __onMouseMove(evt:MouseEvent):void
		{
			var objectsUnderMouse:Array = getObjectsUnderMouse();
			var obj:DisplayObject;
			for each(obj in array.sub(objectsUnderMouseLastTime, objectsUnderMouse)){
				notifyEvt(obj, DragDropEvent.DRAG_EXIT);
			}
			for each(obj in array.sub(objectsUnderMouse, objectsUnderMouseLastTime)){
				notifyEvt(obj, DragDropEvent.DRAG_ENTER);
			}
			objectsUnderMouseLastTime = objectsUnderMouse;
		}
		
		static private function __onMouseUp(evt:MouseEvent):void
		{
			endDrag();
			for each(var obj:DisplayObject in objectsUnderMouseLastTime){
				notifyEvt(obj, DragDropEvent.DRAG_EXIT);
			}
			if(dropTarget && array.has(getObjectsUnderMouse(), dropTarget)){
				notifyEvt(dropTarget, DragDropEvent.DRAG_DROP);
			}
			notifyEvt(dragTarget, DragDropEvent.DRAG_COMPLETE);
			Reset();
		}
		
		static private function notifyEvt(target:DisplayObject, evtType:String):void
		{
			target.dispatchEvent(new DragDropEvent(evtType, dragTarget, dragData));
		}
		
		/**
		 * dragdrop管理器寻找drop目标时可以修改为value.hasEventListener(DragEvent.DRAG_DROP)
		 */		
		static private function getObjectsUnderMouse():Array
		{
			var result:Array = [];
			var source:DisplayObject = dragImage.dropTarget;
			while(source){
				result.push(source);
				source = source.parent;
			}
			return result;
		}
		
		static private function beginDrag():void
		{
			var stage:DisplayObjectContainer = dragTarget.stage;
			
			var rect:Rectangle = dragTarget.getRect(stage);
			dragImage.x = rect.x;
			dragImage.y = rect.y;
			
			dragImage.mouseChildren = dragImage.mouseEnabled = false;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
			stage.addChild(dragImage);
			
			dragImage.startDrag();
		}
		
		static private function endDrag():void
		{
			var stage:DisplayObjectContainer = dragImage.stage;
			
			dragImage.stopDrag();
			
			stage.removeChild(dragImage);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
		}
	}
}