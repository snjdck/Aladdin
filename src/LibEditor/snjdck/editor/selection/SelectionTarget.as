package snjdck.editor.selection
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.signals.Signal;
	
	import snjdck.GDI;
	
	internal class SelectionTarget extends Sprite
	{
		private var target:DisplayObject;
		
		public const clickSignal:Signal = new Signal(DisplayObject);
		
		public function SelectionTarget(target:DisplayObject)
		{
			this.target = target;
			graphics.lineStyle(0, 0xFF0000);
			graphics.beginFill(0, 0);
			GDI.drawRect(graphics, target.getRect(this));
			graphics.endFill();
			
			addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
		}
		
		private function __onMouseDown(evt:MouseEvent):void
		{
			clickSignal.notify(target);
		}
	}
}