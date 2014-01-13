package snjdck.entityengine.nodes
{
	import flash.display.DisplayObject;
	
	import snjdck.entityengine.components.PositionComponent;
	
	public class RenderNode extends DisplayNode
	{
		public var position:PositionComponent;
		
		public function update():void
		{
			var displayObject:DisplayObject = display.displayObject;
			displayObject.x = position.x;
			displayObject.y = position.y;
			displayObject.rotation = position.rotation * 180 / Math.PI;
		}
	}
}