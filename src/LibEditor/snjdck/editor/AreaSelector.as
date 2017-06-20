package snjdck.editor
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.signals.Signal;
	
	public class AreaSelector extends Shape
	{
		static private const selectArea:Rectangle = new Rectangle();
		static private const targetArea:Rectangle = new Rectangle();
		static private const zeroPt:Point = new Point();
		
		private var beginX:Number;
		private var beginY:Number;
		
		private var endX:Number;
		private var endY:Number;
		
		public const updateSignal:Signal = new Signal();
		
		public function AreaSelector(){}
		
		public function begin(evt:MouseEvent):void
		{
			beginX = evt.stageX;
			beginY = evt.stageY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
		}
		
		private function __onMouseMove(evt:MouseEvent):void
		{
			endX = evt.stageX;
			endY = evt.stageY;
			redraw();
			selectArea.setTo(
				Math.min(beginX, endX),
				Math.min(beginY, endY),
				Math.abs(endX - beginX),
				Math.abs(endY - beginY)
			);
			updateSignal.notify();
		}
		
		public function isInArea(target:DisplayObject):Boolean
		{
			var pt:Point = target.localToGlobal(zeroPt);
			targetArea.setTo(pt.x, pt.y, target.width, target.height);
			return selectArea.intersects(targetArea);
		}
		
		private function __onMouseUp(evt:MouseEvent):void
		{
			graphics.clear();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
		}
		
		private function redraw():void
		{
			graphics.clear();
			graphics.lineStyle(0, 0xFF0000);
			graphics.beginFill(0xFF0000, 0.1);
			graphics.drawRect(beginX, beginY, endX - beginX, endY - beginY);
			graphics.endFill();
		}
	}
}