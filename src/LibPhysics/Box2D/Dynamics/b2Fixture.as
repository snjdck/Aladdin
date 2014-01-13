package Box2D.Dynamics
{
	import Box2D.Collision.IBroadPhase;
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.b2RayCastInput;
	import Box2D.Collision.b2RayCastOutput;
	import Box2D.Common.Math.b2Math;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Common.b2internal;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;

	use namespace b2internal;
	
	
	/**
	 * A fixture is used to attach a shape to a body for collision detection. A fixture
	 * inherits its transform from its parent. Fixtures hold additional non-geometric data
	 * such as friction, collision filters, etc.
	 * Fixtures are created via b2Body::CreateFixture.
	 * @warning you cannot reuse fixtures.
	 */
	public class b2Fixture
	{
		/**
		 * Get the type of the child shape. You can use this to down cast to the concrete shape.
		 * @return the shape type.
		 */
		public function GetType():int
		{
			return m_shape.GetType();
		}
		
		/**
		 * Get the child shape. You can modify the child shape, however you should not change the
		 * number of vertices because this will crash some collision caching mechanisms.
		 */
		public function GetShape():b2Shape
		{
			return m_shape;
		}
		
		/**
		 * Set if this fixture is a sensor.
		 */
		public function SetSensor(sensor:Boolean):void
		{
			if(m_isSensor == sensor){
				return;
			}
				
			m_isSensor = sensor;
			
			if(m_body == null){
				return;
			}
				
			var edge:b2ContactEdge = m_body.GetContactList();
			while(edge)
			{
				var contact:b2Contact = edge.contact;
				var fixtureA:b2Fixture = contact.GetFixtureA();
				var fixtureB:b2Fixture = contact.GetFixtureB();
				if(this == fixtureA|| this == fixtureB){
					contact.SetSensor(fixtureA.IsSensor() || fixtureB.IsSensor());
				}
				edge = edge.next;
			}
			
		}
		
		/**
		 * Is this fixture a sensor (non-solid)?
		 * @return the true if the shape is a sensor.
		 */
		public function IsSensor():Boolean
		{
			return m_isSensor;
		}
		
		/**
		 * Set the contact filtering data. This will not update contacts until the next time
		 * step when either parent body is active and awake.
		 */
		public function SetFilterData(filter:b2FilterData):void
		{
			m_filter = filter.Copy();
			
			if(m_body){
				return;
			}
				
			var edge:b2ContactEdge = m_body.GetContactList();
			while(edge)
			{
				var contact:b2Contact = edge.contact;
				if(this == contact.GetFixtureA() || this == contact.GetFixtureB()){
					contact.FlagForFiltering();
				}
				edge = edge.next;
			}
		}
		
		/**
		 * Get the contact filtering data.
		 */
		public function GetFilterData(): b2FilterData
		{
			return m_filter.Copy();
		}
		
		/**
		 * Get the parent body of this fixture. This is NULL if the fixture is not attached.
		 * @return the parent body.
		 */
		public function GetBody():b2Body
		{
			return m_body;
		}
		
		/**
		 * Test a point for containment in this fixture.
		 * @param xf the shape world transform.
		 * @param p a point in world coordinates.
		 */
		public function TestPoint(p:b2Vec2):Boolean
		{
			return m_shape.TestPoint(m_body.GetTransform(), p);
		}
		
		/**
		 * Perform a ray cast against this shape.
		 * @param output the ray-cast results.
		 * @param input the ray-cast input parameters.
		 */
		public function RayCast(output:b2RayCastOutput, input:b2RayCastInput):Boolean
		{
			return m_shape.RayCast(output, input, m_body.GetTransform());
		}
		
		/**
		 * Get the mass data for this fixture. The mass data is based on the density and
		 * the shape. The rotational inertia is about the shape's origin. This operation may be expensive
		 * @param massData - this is a reference to a valid massData, if it is null a new b2MassData is allocated and then returned
		 * @note if the input is null then you must get the return value.
		 */
		public function GetMassData(massData:b2MassData = null):b2MassData
		{
			if(null == massData){
				massData = new b2MassData();
			}
			m_shape.ComputeMass(massData, density);
			return massData;
		}
		
		public function b2Fixture()
		{
		}
		
		/**
		 * the destructor cannot access the allocator (no destructor arguments allowed by C++).
		 *  We need separation create/destroy functions from the constructor/destructor because
		 */
		b2internal function Create(body:b2Body, xf:b2Transform, def:b2FixtureDef):void
		{
			userData = def.userData;
			density = def.density;
			friction = def.friction;
			restitution = def.restitution;
			
			m_body = body;
			next = null;
			
			m_filter = def.filter.Copy();
			m_isSensor = def.isSensor;
			m_shape = def.shape.Copy();
		}
		
		/**
		 * the destructor cannot access the allocator (no destructor arguments allowed by C++).
		 *  We need separation create/destroy functions from the constructor/destructor because
		 */
		b2internal function Destroy():void
		{
			m_shape = null;
		}
		
		/**
		 * This supports body activation/deactivation.
		 */ 
		b2internal function CreateProxy(broadPhase:IBroadPhase, xf:b2Transform):void
		{
			m_shape.ComputeAABB(m_aabb, xf);
			m_proxy = broadPhase.CreateProxy(m_aabb, this);
		}
		
		/**
		 * This supports body activation/deactivation.
		 */
		b2internal function DestroyProxy(broadPhase:IBroadPhase):void
		{
			if(m_proxy){
				broadPhase.DestroyProxy(m_proxy);
				m_proxy = null;
			}
		}
		
		b2internal function Synchronize(broadPhase:IBroadPhase, transform1:b2Transform, transform2:b2Transform):void
		{
			if(null == m_proxy){
				return;
			}
				
			// Compute an AABB that ocvers the swept shape (may miss some rotation effect)
			var aabb1:b2AABB = new b2AABB();
			var aabb2:b2AABB = new b2AABB();
			
			m_shape.ComputeAABB(aabb1, transform1);
			m_shape.ComputeAABB(aabb2, transform2);
			
			m_aabb.Combine(aabb1, aabb2);
			
			var displacement:b2Vec2 = b2Math.SubtractVV(transform2.position, transform1.position);
			broadPhase.MoveProxy(m_proxy, m_aabb, displacement);
		}
		
		/** 密度 */
		public var density:Number = 0;
		/** 摩擦 */
		public var friction:Number = 0;
		/** 弹性 */
		public var restitution:Number = 0;
		
		public var userData:*;
		public var next:b2Fixture;
		
		public const m_aabb:b2AABB = new b2AABB();
		b2internal var m_body:b2Body;
		b2internal var m_shape:b2Shape;
		
		b2internal var m_proxy:*;
		private var m_filter:b2FilterData = new b2FilterData();
		private var m_isSensor:Boolean;
	}
}