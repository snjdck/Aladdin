package Box2D.Dynamics 
{
	import Box2D.Common.b2Settings;
	
	/**
	 * Contact impulses for reporting. Impulses are used instead of forces because
	 * sub-step forces may approach infinity for rigid body collisions. These
	 * match up one-to-one with the contact points in b2Manifold.
	 */
	public class b2ContactImpulse 
	{
		public const normalImpulses:Vector.<Number> = new Vector.<Number>(b2Settings.b2_maxManifoldPoints);
		public const tangentImpulses:Vector.<Number> = new Vector.<Number>(b2Settings.b2_maxManifoldPoints);
		
		public function b2ContactImpulse()
		{
		}
	}
}