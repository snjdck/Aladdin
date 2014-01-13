package snjdck.entityengine.components
{
	import snjdck.entityengine.IComponent;

	public class IdComponent implements IComponent
	{
		public var id:String;
		
		public function IdComponent(id:String)
		{
			this.id = id;
		}
	}
}