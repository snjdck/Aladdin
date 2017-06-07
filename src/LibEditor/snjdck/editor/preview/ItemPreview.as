package snjdck.editor.preview
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import math.calcScaleRatio;
	
	import snjdck.GDI;
	import snjdck.ui.layout.LayoutObject;
	
	public class ItemPreview extends LayoutObject
	{
		private var w:int = 200;
		private var h:int = 200;
		
		public function ItemPreview()
		{
			mouseChildren = false;
			graphics.beginFill(0xFFFF00);
			GDI.drawRect(graphics, new Rectangle(0, 0, w, h));
		}
		
		public function showPreview(target:DisplayObject):void
		{
			removeChildren();
			if(target != null){
				addChild(target);
				adjustTarget(target);
			}
		}
		
		private function adjustTarget(target:DisplayObject):void
		{
			var ratio:Number = calcScaleRatio(target.width, target.height, w, h);
			target.scaleX = target.scaleY = ratio;
			target.x = 0.5 * (w - ratio * target.width);
			target.y = 0.5 * (h - ratio * target.height);
		}
	}
}