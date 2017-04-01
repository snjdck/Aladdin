package snjdck.ui.layout
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class LayoutContainer
	{
		public var numPerRow:int = 1;
		
		public var offsetX:Number = 0;
		public var offsetY:Number = 0;
		
		public var marginX:Number = 0;
		public var marginY:Number = 0;
		
		public var alignX:int = -1;
		public var alignY:int = -1;
		
		public var gridWidth:Number = 0;
		public var gridHeight:Number = 0;
		
		public var forceWidth:Boolean;
		public var forceHeight:Boolean;
		
		private var _target:Sprite;
		
		public function LayoutContainer(target:Sprite)
		{
			_target = target;
		}
		
		public function layout():void
		{
			for(var i:int=0; i<_target.numChildren; ++i){
				var layoutObject:DisplayObject = _target.getChildAt(i);
				var newX:Number = offsetX;
				var newY:Number = offsetY;
				if(forceWidth){
					layoutObject.width = gridWidth;
				}else{
					newX += getAlignOffsetX(layoutObject.width);
				}
				if(forceHeight){
					layoutObject.height = gridHeight;
				}else{
					newY += getAlignOffsetY(layoutObject.height);
				}
				layoutObject.x = newX + (marginX + gridWidth) * (i % numPerRow);
				layoutObject.y = newY + (marginY + gridHeight) * int(i / numPerRow);
			}
		}
		
		private function getAlignOffsetX(childWidth:Number):Number
		{
			if(alignX == 0){
				return (gridWidth - childWidth) * 0.5;
			}
			if(alignX > 0){
				return gridWidth - childWidth;
			}
			return 0;
		}
		
		private function getAlignOffsetY(childHeight:Number):Number
		{
			if(alignY == 0){
				return (gridHeight - childHeight) * 0.5;
			}
			if(alignY > 0){
				return gridHeight - childHeight;
			}
			return 0;
		}
	}
}