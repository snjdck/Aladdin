package snjdck.g2d.render
{
	import snjdck.gpu.state.StateStack;

	internal class Projection2DStack
	{
		private const stack:StateStack = new StateStack(Projection2D);
		
		public function Projection2DStack(){}
		
		public function get projection():Projection2D
		{
			return stack.state;
		}
		
		public function pushScreen(width:int, height:int, offsetX:Number=0, offsetY:Number=0):void
		{
			stack.push();
			var projection:Projection2D = stack.state;
			projection.resize(width, height);
			projection.offset(offsetX, offsetY);
		}
		
		public function popScreen():void
		{
			stack.pop();
		}
	}
}