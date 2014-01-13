package snjdck.game.common.board
{
	import flash.display.DisplayObject;

	internal class HoverLayer extends Layer
	{
		private var icon:DisplayObject;
		
		public function HoverLayer(boxWidth:int, boxHeight:int, gapWidth:int, gapHeight:int)
		{
			super(boxWidth, boxHeight, gapWidth, gapHeight);
		}
		
		public function setIcon(icon:DisplayObject):void
		{
			this.icon = icon;
			icon.visible = false;
			this.addChild(icon);
		}
		
		public function showIcon(flag:Boolean):void
		{
			icon.visible = flag;
		}
			
		public function moveIcon(px:int, py:int):void
		{
			this.moveChildTo(icon, px, py);
		}
		//over
	}
}