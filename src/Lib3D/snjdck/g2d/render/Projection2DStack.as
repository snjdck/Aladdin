package snjdck.g2d.render
{
	public class Projection2DStack
	{
		private var projectionStack:Vector.<Projection2D>;
		private var projectionIndex:int;
		
		public function Projection2DStack()
		{
			projectionStack = new Vector.<Projection2D>();
			projectionIndex = -1;
		}
		
		public function get projection():Projection2D
		{
			return projectionStack[projectionIndex];
		}
		
		public function pushScreen(width:int, height:int, offsetX:Number=0, offsetY:Number=0):void
		{
			++projectionIndex;
			if(projectionStack.length <= projectionIndex){
				projectionStack.push(new Projection2D());
			}
			projection.resize(width, height);
			projection.offset(offsetX, offsetY);
		}
		
		public function popScreen():void
		{
			--projectionIndex;
		}
	}
}