package snjdck.g3d.skeleton
{
	final public class KeyFrame
	{
		public var time:Number;
		public var transform:Transform;
		
		public function KeyFrame(time:Number, transform:Transform=null)
		{
			this.time = time;
			this.transform = transform || new Transform();
		}
	}
}