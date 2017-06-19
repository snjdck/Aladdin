package snjdck.editor.selection
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import snjdck.GDI;
	
	internal class SelectionTarget extends Sprite
	{
		internal var target:DisplayObject;
		
		private var targetX:Number;
		private var targetY:Number;
		
		public function SelectionTarget(target:DisplayObject)
		{
			this.target = target;
			redraw();
		}
		
		private function redraw():void
		{
			graphics.clear();
			graphics.lineStyle(0, 0xFF0000);
			graphics.beginFill(0, 0);
			GDI.drawRect(graphics, target.getRect(this));
			graphics.endFill();
		}
		
		public function saveTargetXY():void
		{
			targetX = target.x;
			targetY = target.y;
		}
		
		public function updateTargetXY(dx:Number, dy:Number):void
		{
			target.x = targetX + dx;
			target.y = targetY + dy;
			redraw();
		}
	}
}