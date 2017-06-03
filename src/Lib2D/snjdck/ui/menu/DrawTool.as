package snjdck.ui.menu
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;

	internal class DrawTool
	{
		static public function DrawMenuBG(menu:Menu, w:Number, h:Number):void
		{
			var g:Graphics = menu.graphics;
			g.clear();
			g.beginFill(0x999999);
			g.drawRect(-1,-1,w+2,h+2);
			g.drawRect(0,0,w,h);
			g.endFill();
			g.beginFill(menu.themeColor);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		
		static public function DrawMenuItemBG(g:Graphics, w:Number, h:Number, color:uint=0, alpha:Number=0):void
		{
			g.clear();
			g.beginFill(color, alpha);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		
		static public function CreateIcon():DisplayObject
		{
			var sp:Shape = new Shape();
			var g:Graphics = sp.graphics;
			
			var size:int = 3;
			g.lineStyle(0);
			g.moveTo(0, 0);
			g.lineTo(size, size);
			g.lineTo(0, size * 2);
			
			return sp;
		}
		
		static public function RenderMenu(menu:Menu, itemList:Vector.<IMenuItem>):void
		{
			var maxWidth:Number = menu.marginLeft + menu.calcWidth() + menu.marginRight;
			
			DrawMenuBG(menu, maxWidth + menu.margin * 2, menu.calcHeight() + menu.margin * 2);
			menu.graphics.beginFill(0xCCCCCC);
			
			var nextY:Number = menu.margin;
			for each(var item:IMenuItem in itemList){
				item.render(menu, maxWidth, nextY);
				nextY += item.getHeight();
			}
			
			menu.graphics.endFill();
		}
	}
}