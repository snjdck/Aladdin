package Box2D.Collision 
{
	import Box2D.Common.Math.b2Transform;
	
	/**
	 * Input for b2Distance.
	 * You have to option to use the shape radii
	 * in the computation. Even 
	 */
	public class b2DistanceInput
	{
		public var proxyA:b2DistanceProxy;
		public var transformA:b2Transform;
		
		public var proxyB:b2DistanceProxy;
		public var transformB:b2Transform;
		
		public var useRadii:Boolean;
	}
}