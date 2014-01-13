package Box2D.Collision 
{
	import Box2D.Common.Math.b2Sweep;
	
	/**
	 * Inpute parameters for b2TimeOfImpact
	 */
	public class b2TOIInput 
	{
		public const proxyA:b2DistanceProxy = new b2DistanceProxy();
		public const proxyB:b2DistanceProxy = new b2DistanceProxy();
		public var sweepA:b2Sweep = new b2Sweep();
		public var sweepB:b2Sweep = new b2Sweep();
		public var tolerance:Number;
		
	}
}