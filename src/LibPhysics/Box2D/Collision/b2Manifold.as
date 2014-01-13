package Box2D.Collision
{
	import Box2D.Common.b2Settings;
	import Box2D.Common.Math.b2Vec2;
	
	/**
	 * A manifold for two touching convex shapes.
	 * Box2D supports multiple types of contact:
	 * - clip point versus plane with radius
	 * - point versus point with radius (circles)
	 * The local point usage depends on the manifold type:
	 * -e_circles: the local center of circleA
	 * -e_faceA: the center of faceA
	 * -e_faceB: the center of faceB
	 * Similarly the local normal usage:
	 * -e_circles: not used
	 * -e_faceA: the normal on polygonA
	 * -e_faceB: the normal on polygonB
	 * We store contacts in this way so that position correction can
	 * account for movement, which is critical for continuous physics.
	 * All contact scenarios must be expressed in one of these types.
	 * This structure is stored across time steps, so we keep it small.
	 */
	public class b2Manifold
	{
		public function b2Manifold()
		{
			m_points = new Vector.<b2ManifoldPoint>(b2Settings.b2_maxManifoldPoints);
			for (var i:int = 0; i < b2Settings.b2_maxManifoldPoints; i++){
				m_points[i] = new b2ManifoldPoint();
			}
		}
		
		public function Reset():void
		{
			for (var i:int = 0; i < b2Settings.b2_maxManifoldPoints; i++){
				(m_points[i] as b2ManifoldPoint).Reset();
			}
			m_localPlaneNormal.SetZero();
			m_localPoint.SetZero();
			m_type = 0;
			m_pointCount = 0;
		}
		
		public function Set(m:b2Manifold):void
		{
			m_pointCount = m.m_pointCount;
			for (var i:int = 0; i < b2Settings.b2_maxManifoldPoints; i++){
				(m_points[i] as b2ManifoldPoint).Set(m.m_points[i]);
			}
			m_localPlaneNormal.SetV(m.m_localPlaneNormal);
			m_localPoint.SetV(m.m_localPoint);
			m_type = m.m_type;
		}
		
		public function Copy():b2Manifold
		{
			var copy:b2Manifold = new b2Manifold();
			copy.Set(this);
			return copy;
		}
		/** The points of contact */	
		public var m_points:Vector.<b2ManifoldPoint>;
		/** Not used for Type e_points*/	
		public const m_localPlaneNormal:b2Vec2 = new b2Vec2();	
		/** Usage depends on manifold type */	
		public const m_localPoint:b2Vec2 = new b2Vec2();	
		public var m_type:int;
		/** The number of manifold points */	
		public var m_pointCount:int;
		
		//enum Type
		public static const e_circles:int = 0x0001;
		public static const e_faceA:int = 0x0002;
		public static const e_faceB:int = 0x0004;
	}
}