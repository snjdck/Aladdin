package snjdck.ui.menu
{
	import flash.display.Graphics;

	internal class Separator implements IMenuItem
	{
		public function Separator()
		{
		}
		
		public function getHeight():Number
		{
			return 5;
		}
		
		public function getWidth():Number
		{
			return 0;
		}
		
		public function render(menu:Menu, maxWidth:Number, nextY:Number):void
		{
			var g:Graphics = menu.graphics;
			g.drawRect(menu.margin + menu.marginLeft, nextY + 2, maxWidth - menu.marginLeft, 1);
		}
	}
}