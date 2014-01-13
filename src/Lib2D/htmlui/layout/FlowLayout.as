package htmlui.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class FlowLayout extends Layout
	{
		public function FlowLayout(target:DisplayObjectContainer)
		{
			super(target);
		}
		
		override protected function relayout():void
		{
			var startX:Number = 0;
			var startY:Number = 0;
			
			for each(var child:DisplayObject in _elementList){
				child.x = startX;
				child.y = startY;
				
				startX += child.width;
			}
		}
	}
}