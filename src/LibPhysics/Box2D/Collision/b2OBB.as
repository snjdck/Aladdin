package Box2D.Collision
{
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Vec2;
	
	/**
	* An oriented bounding box.
	*/
	public class b2OBB
	{
		/** The rotation matrix */
		public const R:b2Mat22 = new b2Mat22();
		/** The local centroid */
		public const center:b2Vec2 = new b2Vec2();
		/** The half-widths */
		public const extents:b2Vec2 = new b2Vec2();
	}
}