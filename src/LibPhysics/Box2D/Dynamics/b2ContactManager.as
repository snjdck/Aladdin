package Box2D.Dynamics
{
	import Box2D.Collision.IBroadPhase;
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Collision.b2DynamicTreeBroadPhase;
	import Box2D.Common.b2internal;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Contacts.b2ContactEdge;
	import Box2D.Dynamics.Contacts.b2ContactFactory;

	use namespace b2internal;
	
	
	// Delegate of b2World.
	/**
	* @private
	*/
	public class b2ContactManager 
	{
		public function b2ContactManager()
		{
			m_contactFilter = new b2DefaultContactFilter();
			m_contactListener = new b2DefaultContactListener();
			m_contactFactory = new b2ContactFactory(m_allocator);
			m_broadPhase = new b2DynamicTreeBroadPhase();
		}
	
		// This is a callback from the broadphase when two AABB proxies begin
		// to overlap. We create a b2Contact to manage the narrow phase.
		public function AddPair(proxyUserDataA:*, proxyUserDataB:*):void
		{
			var fixtureA:b2Fixture = proxyUserDataA;
			var fixtureB:b2Fixture = proxyUserDataB;
			
			var bodyA:b2Body = fixtureA.GetBody();
			var bodyB:b2Body = fixtureB.GetBody();
			
			// Are the fixtures on the same body?
			if (bodyA == bodyB){
				return;
			}
			
			// Does a contact already exist?
			var edge:b2ContactEdge = bodyB.GetContactList();
			while(edge)
			{
				if(edge.other == bodyA)
				{
					var fA:b2Fixture = edge.contact.GetFixtureA();
					var fB:b2Fixture = edge.contact.GetFixtureB();
					if(fA == fixtureA && fB == fixtureB){
						return;
					}
					if(fA == fixtureB && fB == fixtureA){
						return;
					}
				}
				edge = edge.next;
			}
			
			//Does a joint override collision? Is at least one body dynamic?
			if(bodyB.ShouldCollide(bodyA) == false){
				return;
			}
			
			// Check user filtering
			if(m_contactFilter.ShouldCollide(fixtureA, fixtureB) == false){
				return;
			}
			
			// Call the factory.
			var c:b2Contact = m_contactFactory.Create(fixtureA, fixtureB);
			
			// Contact creation may swap shapes.
			fixtureA = c.GetFixtureA();
			fixtureB = c.GetFixtureB();
			
			bodyA = fixtureA.m_body;
			bodyB = fixtureB.m_body;
			
			// Insert into the world.
			c.m_prev = null;
			c.m_next = m_world.m_contactList;
			
			if(m_world.m_contactList){
				m_world.m_contactList.m_prev = c;
			}
			
			m_world.m_contactList = c;
			
			
			// Connect to island graph.
			
			// Connect to body A
			c.m_nodeA.contact = c;
			c.m_nodeA.other = bodyB;
			
			c.m_nodeA.prev = null;
			c.m_nodeA.next = bodyA.m_contactList;
			if (bodyA.m_contactList){
				bodyA.m_contactList.prev = c.m_nodeA;
			}
			bodyA.m_contactList = c.m_nodeA;
			
			// Connect to body 2
			c.m_nodeB.contact = c;
			c.m_nodeB.other = bodyA;
			
			c.m_nodeB.prev = null;
			c.m_nodeB.next = bodyB.m_contactList;
			if (bodyB.m_contactList){
				bodyB.m_contactList.prev = c.m_nodeB;
			}
			bodyB.m_contactList = c.m_nodeB;
			
			++m_world.m_contactCount;
		}
	
		public function FindNewContacts():void
		{
			m_broadPhase.UpdatePairs(AddPair);
		}
		
		static private const s_evalCP:b2ContactPoint = new b2ContactPoint();
		public function Destroy(c:b2Contact):void
		{
			var fixtureA:b2Fixture = c.GetFixtureA();
			var fixtureB:b2Fixture = c.GetFixtureB();
			
			var bodyA:b2Body = fixtureA.GetBody();
			var bodyB:b2Body = fixtureB.GetBody();
			
			if(c.IsTouching()){
				m_contactListener.EndContact(c);
			}
			
			// Remove from the world.
			if(c.m_prev){
				c.m_prev.m_next = c.m_next;
			}
			
			if(c.m_next){
				c.m_next.m_prev = c.m_prev;
			}
			
			if(c == m_world.m_contactList){
				m_world.m_contactList = c.m_next;
			}
			
			// Remove from body A
			if(c.m_nodeA.prev){
				c.m_nodeA.prev.next = c.m_nodeA.next;
			}
			
			if(c.m_nodeA.next){
				c.m_nodeA.next.prev = c.m_nodeA.prev;
			}
			
			if(c.m_nodeA == bodyA.m_contactList){
				bodyA.m_contactList = c.m_nodeA.next;
			}
			
			// Remove from body 2
			if(c.m_nodeB.prev){
				c.m_nodeB.prev.next = c.m_nodeB.next;
			}
			
			if(c.m_nodeB.next){
				c.m_nodeB.next.prev = c.m_nodeB.prev;
			}
			
			if(c.m_nodeB == bodyB.m_contactList){
				bodyB.m_contactList = c.m_nodeB.next;
			}
			
			// Call the factory.
			m_contactFactory.Destroy(c);
			--m_contactCount;
		}
		
	
		// This is the top level collision call for the time step. Here
		// all the narrow phase collision is processed for the world
		// contact list.
		public function Collide():void
		{
			var cNuke:b2Contact;
			// Update awake contacts.
			var c:b2Contact = m_world.m_contactList;
			while(c)
			{
				var fixtureA:b2Fixture = c.GetFixtureA();
				var fixtureB:b2Fixture = c.GetFixtureB();
				
				var bodyA:b2Body = fixtureA.GetBody();
				var bodyB:b2Body = fixtureB.GetBody();
				
				if(bodyA.IsAwake() == false && bodyB.IsAwake() == false)
				{
					c = c.GetNext();
					continue;
				}
				
				// Is this contact flagged for filtering?
				if (c.hasFlag(b2Contact.e_filterFlag))
//				if (c.m_flags & b2Contact.e_filterFlag)
				{
					// Should these bodies collide?
					if (bodyB.ShouldCollide(bodyA) == false)
					{
						cNuke = c;
						c = c.GetNext();
						Destroy(cNuke);
						continue;
					}
					
					// Check user filtering.
					if (m_contactFilter.ShouldCollide(fixtureA, fixtureB) == false)
					{
						cNuke = c;
						c = c.GetNext();
						Destroy(cNuke);
						continue;
					}
					
					// Clear the filtering flag
					c.clearFlag(b2Contact.e_filterFlag);
//					c.m_flags &= ~b2Contact.e_filterFlag;
				}
				
				// Here we destroy contacts that cease to overlap in the broadphase
				if(false == m_broadPhase.TestOverlap(fixtureA.m_proxy, fixtureB.m_proxy))
				{
					cNuke = c;
					c = c.GetNext();
					Destroy(cNuke);
					continue;
				}
				
				c.Update(m_contactListener);
				c = c.GetNext();
			}
		}
		
		b2internal var m_world:b2World;
		b2internal var m_broadPhase:IBroadPhase;
		
		b2internal var m_contactList:b2Contact;
		b2internal var m_contactCount:int;
		b2internal var m_contactFilter:b2ContactFilter;
		b2internal var m_contactListener:b2ContactListener;
		b2internal var m_contactFactory:b2ContactFactory;
		b2internal var m_allocator:*;
	}
}