package snjdck.entityengine.components
{
	import flash.display.DisplayObject;
	
	import snjdck.entityengine.IComponent;

	public class DisplayComponent implements IComponent
	{
		public var displayObject:DisplayObject;
		
		public function DisplayComponent(displayObject:DisplayObject)
		{
			this.displayObject = displayObject;
		}
	}
}