package snjdck.gpu.projectionstack
{
	import snjdck.gpu.projection.OrthoProjection3D;

	public class OrthoProjection3DStack implements IProjectionStack
	{
		private var projectionStack:Vector.<OrthoProjection3D>;
		private var projectionIndex:int;
		
		public function OrthoProjection3DStack()
		{
			projectionStack = new Vector.<OrthoProjection3D>();
			projectionIndex = -1;
		}
		
		public function get projection():OrthoProjection3D
		{
			return projectionStack[projectionIndex];
		}
		
		public function pushScreen(width:int, height:int, offsetX:Number=0, offsetY:Number=0):void
		{
			++projectionIndex;
			if(projectionStack.length <= projectionIndex){
				projectionStack.push(new OrthoProjection3D());
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