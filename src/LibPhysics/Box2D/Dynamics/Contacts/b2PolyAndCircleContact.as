package Box2D.Dynamics.Contacts
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2Collision;
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2internal;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;

	use namespace b2internal;
	
	
	/**
	* @private
	*/
	public class b2PolyAndCircleContact extends b2Contact
	{
		static public function Create(allocator:*):b2Contact
		{
			return new b2PolyAndCircleContact();
		}
		
		static public function Destroy(contact:b2Contact, allocator:*):void
		{
		}
	
		public function Reset(fixtureA:b2Fixture, fixtureB:b2Fixture):void
		{
			super.Reset(fixtureA, fixtureB);
		}
	
		b2internal override function Evaluate():void
		{
			b2Collision.CollidePolygonAndCircle(
				m_manifold,
				m_fixtureA.GetShape() as b2PolygonShape,
				m_fixtureA.m_body.m_xf, 
				m_fixtureB.GetShape() as b2CircleShape,
				m_fixtureB.m_body.m_xf
			);
		}
	}

}