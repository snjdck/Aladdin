package Box2D.Collision 
{
	import Box2D.Common.Math.b2Vec2;
	
	/**
	 * Output for b2Distance.
	 */
	public class b2DistanceOutput 
	{
		/** Closest point on shapea */
		public const pointA:b2Vec2 = new b2Vec2();
		
		/** Closest point on shapeb */
		public const pointB:b2Vec2 = new b2Vec2();
		
		public var distance:Number;
		
		/** Number of gjk iterations used */
		public var iterations:int;
	}
}