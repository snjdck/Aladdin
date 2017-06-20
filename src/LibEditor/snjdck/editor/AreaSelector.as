package snjdck.editor
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import snjdck.editor.selection.SelectionLayer;
	
	public class AreaSelector extends Shape
	{
		static private const selectArea:Rectangle = new Rectangle();
		static private const targetArea:Rectangle = new Rectangle();
		
		private var beginX:Number;
		private var beginY:Number;
		
		private var endX:Number;
		private var endY:Number;
		
		private var selectionLayer:SelectionLayer;
		
		private var app:Object;
		
		public function AreaSelector(app:Object)
		{
			this.app = app;
			this.selectionLayer = app["selectionLayer"];
		}
		
		private function get editArea():DisplayObjectContainer
		{
			return app["editArea"];
		}
		
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
			for(var i:int=0; i<editArea.numChildren; ++i){
				var item:DisplayObject = editArea.getChildAt(i);
				var pt:Point = item.localToGlobal(new Point());
				targetArea.setTo(pt.x, pt.y, item.width, item.height);
				if(selectArea.intersects(targetArea)){
					selectionLayer.addSelection(item);
				}else{
					selectionLayer.delSelection(item);
				}
			}
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