package Box2D.Collision
{
	import flash.utils.Dictionary;
		
	/**
	* @private
	*/
	public class b2Proxy
	{
		public function IsValid():Boolean
		{
			return overlapCount != b2BroadPhase.b2_invalid
		}
	
		public const lowerBounds:Vector.<uint> = new Vector.<uint>(2);
		public const upperBounds:Vector.<uint> = new Vector.<uint>(2);
		
		public var overlapCount:uint;
		public var timeStamp:uint;
		
		// Maps from the other b2Proxy to their mutual b2Pair.
		public const pairs:Object = new Dictionary();
		
		public var next:b2Proxy;
		
		public var userData:*;
	}
}