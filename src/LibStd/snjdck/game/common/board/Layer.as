package snjdck.game.common.board
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	internal class Layer extends Sprite
	{
		protected var boxWidth:int;			//格子宽度
		protected var boxHeight:int;		//格子高度
		
		protected var gapWidth:int;			//横向格子间距
		protected var gapHeight:int;		//纵向格子间距
		
		public function Layer(boxWidth:int, boxHeight:int, gapWidth:int, gapHeight:int)
		{
			super();
			
			this.boxWidth = boxWidth;
			this.boxHeight = boxHeight;
			this.gapWidth = gapWidth;
			this.gapHeight = gapHeight;
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		/**
		 * 注意,child的注册点在中心	
		 * @param child 要移动的显示对象
		 * @param px 横向位置
		 * @param py 纵向位置
		 * 
		 */		
		final protected function moveChildTo(child:DisplayObject, px:int, py:int):void
		{
			child.x = (boxWidth + gapWidth) * px + boxWidth * 0.5;
			child.y = (boxHeight + gapHeight) * py + boxHeight * 0.5;
		}
		//over
	}
}