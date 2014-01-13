package Box2D.Collision
{
	import Box2D.Common.Math.b2Vec2;
	
	/**
	 * A manifold point is a contact point belonging to a contact
	 * manifold. It holds details related to the geometry and dynamics
	 * of the contact points.
	 * The local point usage depends on the manifold type:
	 * -e_circles: the local center of circleB
	 * -e_faceA: the local center of cirlceB or the clip point of polygonB
	 * -e_faceB: the clip point of polygonA
	 * This structure is stored across time steps, so we keep it small.
	 * Note: the impulses are used for internal caching and may not
	 * provide reliable contact forces, especially for high speed collisions.
	 */
	public class b2ManifoldPoint
	{
		public function b2ManifoldPoint()
		{
			Reset();
		}
		
		public function Reset():void
		{
			m_localPoint.SetZero();
			m_normalImpulse = 0.0;
			m_tangentImpulse = 0.0;
			m_id.key = 0;
		}
		
		public function Set(m:b2ManifoldPoint):void
		{
			m_localPoint.SetV(m.m_localPoint);
			m_normalImpulse = m.m_normalImpulse;
			m_tangentImpulse = m.m_tangentImpulse;
			m_id.Set(m.m_id);
		}
		
		public const m_localPoint:b2Vec2 = new b2Vec2();
		public var m_normalImpulse:Number;
		public var m_tangentImpulse:Number;
		public const m_id:b2ContactID = new b2ContactID();
	}
}