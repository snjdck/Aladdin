package Box2D.Collision
{
	/**
	 * A Pair represents a pair of overlapping b2Proxy in the broadphse.
	 * @private
	 */
	public class b2Pair
	{
		public var next:b2Pair;
	
		public var proxy1:b2Proxy;
		public var proxy2:b2Proxy;
		public var userData:*;
		
		public var isBuffered:Boolean;
		public var isRemoved:Boolean;
		public var isFinal:Boolean;
		
		public function ClearStatus():void
		{
			isBuffered = isRemoved = isFinal = false;
		}
	}
}