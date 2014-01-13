package Box2D.Dynamics.Contacts
{
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2ContactID;
	import Box2D.Collision.b2Manifold;
	import Box2D.Collision.b2ManifoldPoint;
	import Box2D.Collision.b2TOIInput;
	import Box2D.Collision.b2TimeOfImpact;
	import Box2D.Collision.b2WorldManifold;
	import Box2D.Common.FlagSet;
	import Box2D.Common.Math.b2Sweep;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.b2Settings;
	import Box2D.Common.b2internal;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2Fixture;

	use namespace b2internal;
	
	
	//typedef b2Contact* b2ContactCreateFcn(b2Shape* shape1, b2Shape* shape2, b2BlockAllocator* allocator);
	//typedef void b2ContactDestroyFcn(b2Contact* contact, b2BlockAllocator* allocator);
	
	
	
	/**
	* The class manages contact between two shapes. A contact exists for each overlapping
	* AABB in the broad-phase (except if filtered). Therefore a contact object may exist
	* that has no contact points.
	*/
	public class b2Contact
	{
		/**
		 * Get the contact manifold. Do not modify the manifold unless you understand the
		 * internals of Box2D
		 */
		public function GetManifold():b2Manifold
		{
			return m_manifold;
		}
		
		/**
		 * Get the world manifold
		 */
		public function GetWorldManifold(worldManifold:b2WorldManifold):void
		{
			var bodyA:b2Body = m_fixtureA.GetBody();
			var bodyB:b2Body = m_fixtureB.GetBody();
			var shapeA:b2Shape = m_fixtureA.GetShape();
			var shapeB:b2Shape = m_fixtureB.GetShape();
			
			worldManifold.Initialize(m_manifold, bodyA.GetTransform(), shapeA.m_radius, bodyB.GetTransform(), shapeB.m_radius);
		}
		
		/**
		 * Is this contact touching.
		 */
		public function IsTouching():Boolean
		{
			return hasFlag(e_touchingFlag);
		}
		
		/**
		 * Does this contact generate TOI events for continuous simulation
		 */
		public function IsContinuous():Boolean
		{
			return hasFlag(e_continuousFlag);
		}
		
		/**
		 * Change this to be a sensor or-non-sensor contact.
		 */
		public function SetSensor(sensor:Boolean):void{
			if(sensor){
				addFlag(e_sensorFlag);
			}else{
				clearFlag(e_sensorFlag);
			}
		}
		
		/**
		 * Is this contact a sensor?
		 */
		public function IsSensor():Boolean
		{
			return hasFlag(e_sensorFlag);
		}
		
		/**
		 * Enable/disable this contact. This can be used inside the pre-solve
		 * contact listener. The contact is only disabled for the current
		 * time step (or sub-step in continuous collision).
		 */
		public function SetEnabled(flag:Boolean):void
		{
			if(flag){
				addFlag(e_enabledFlag);
			}else{
				clearFlag(e_enabledFlag);
			}
		}
		
		/**
		 * Has this contact been disabled?
		 * @return
		 */
		public function IsEnabled():Boolean
		{
			return hasFlag(e_enabledFlag);
		}
		
		/**
		* Get the next contact in the world's contact list.
		*/
		public function GetNext():b2Contact{
			return m_next;
		}
		
		/**
		* Get the first fixture in this contact.
		*/
		public function GetFixtureA():b2Fixture
		{
			return m_fixtureA;
		}
		
		/**
		* Get the second fixture in this contact.
		*/
		public function GetFixtureB():b2Fixture
		{
			return m_fixtureB;
		}
		
		/**
		 * Flag this contact for filtering. Filtering will occur the next time step.
		 */
		public function FlagForFiltering():void
		{
			addFlag(e_filterFlag);
		}
	
		//--------------- Internals Below -------------------
		
		// m_flags
		// enum
		// This contact should not participate in Solve
		// The contact equivalent of sensors
		static b2internal const e_sensorFlag:uint		= 0x0001;
		// Generate TOI events.
		static b2internal const e_continuousFlag:uint	= 0x0002;
		// Used when crawling contact graph when forming islands.
		static b2internal const e_islandFlag:uint		= 0x0004;
		// Used in SolveTOI to indicate the cached toi value is still valid.
		static b2internal const e_toiFlag:uint		= 0x0008;
		// Set when shapes are touching
		static b2internal const e_touchingFlag:uint	= 0x0010;
		// This contact can be disabled (by user)
		static b2internal const e_enabledFlag:uint	= 0x0020;
		// This contact needs filtering because a fixture filter was changed.
		static b2internal const e_filterFlag:uint		= 0x0040;
	
		public function b2Contact()
		{
			// Real work is done in Reset
		}
		
		/** @private */
		b2internal function Reset(fixtureA:b2Fixture = null, fixtureB:b2Fixture = null):void
		{
			m_flags.clearAllFlags();
			m_flags.addFlag(e_enabledFlag);
			
			if (!fixtureA || !fixtureB){
				m_fixtureA = null;
				m_fixtureB = null;
				return;
			}
			
			if (fixtureA.IsSensor() || fixtureB.IsSensor())
			{
				addFlag(e_sensorFlag);
			}
			
			var bodyA:b2Body = fixtureA.GetBody();
			var bodyB:b2Body = fixtureB.GetBody();
			
			if (bodyA.GetType() != b2Body.b2_dynamicBody || bodyA.IsBullet() || bodyB.GetType() != b2Body.b2_dynamicBody || bodyB.IsBullet())
			{
				addFlag(e_continuousFlag);
			}
			
			m_fixtureA = fixtureA;
			m_fixtureB = fixtureB;
			
			m_manifold.m_pointCount = 0;
			
			m_prev = null;
			m_next = null;
			
			m_nodeA.contact = null;
			m_nodeA.prev = null;
			m_nodeA.next = null;
			m_nodeA.other = null;
			
			m_nodeB.contact = null;
			m_nodeB.prev = null;
			m_nodeB.next = null;
			m_nodeB.other = null;
		}
		
		b2internal function Update(listener:b2ContactListener):void
		{
			// Swap old & new manifold
			var tManifold:b2Manifold = m_oldManifold;
			m_oldManifold = m_manifold;
			m_manifold = tManifold;
			
			// Re-enable this contact
			addFlag(e_enabledFlag);
			
			const wasTouching:Boolean = hasFlag(e_touchingFlag);
			var touching:Boolean = false;
			
			const bodyA:b2Body = m_fixtureA.m_body;
			const bodyB:b2Body = m_fixtureB.m_body;
			
			const aabbOverlap:Boolean = m_fixtureA.m_aabb.TestOverlap(m_fixtureB.m_aabb);
			
			// Is this contat a sensor?
			if(hasFlag(e_sensorFlag)){
				if(aabbOverlap){
					var shapeA:b2Shape = m_fixtureA.GetShape();
					var shapeB:b2Shape = m_fixtureB.GetShape();
					var xfA:b2Transform = bodyA.GetTransform();
					var xfB:b2Transform = bodyB.GetTransform();
					touching = b2Shape.TestOverlap(shapeA, xfA, shapeB, xfB);
				}
				// Sensors don't generate manifolds
				m_manifold.m_pointCount = 0;
			}else{
				// Slow contacts don't generate TOI events.
				if(
					bodyA.GetType() != b2Body.b2_dynamicBody ||
					bodyA.IsBullet() ||
					bodyB.GetType() != b2Body.b2_dynamicBody ||
					bodyB.IsBullet()
				){
					addFlag(e_continuousFlag);
				}else{
					clearFlag(e_continuousFlag);
				}
				
				if(aabbOverlap){
					Evaluate();
					
					touching = m_manifold.m_pointCount > 0;
					
					// Match old contact ids to new contact ids and copy the
					// stored impulses to warm start the solver.
					for(var i:int=0; i < m_manifold.m_pointCount; ++i){
						var mp2:b2ManifoldPoint = m_manifold.m_points[i];
						mp2.m_normalImpulse = 0.0;
						mp2.m_tangentImpulse = 0.0;
						var id2:b2ContactID = mp2.m_id;
	
						for(var j:int=0; j < m_oldManifold.m_pointCount; ++j){
							var mp1:b2ManifoldPoint = m_oldManifold.m_points[j];
							if(mp1.m_id.key == id2.key){
								mp2.m_normalImpulse = mp1.m_normalImpulse;
								mp2.m_tangentImpulse = mp1.m_tangentImpulse;
								break;
							}
						}
					}
				}else{
					m_manifold.m_pointCount = 0;
				}
				if(touching != wasTouching){
					bodyA.SetAwake(true);
					bodyB.SetAwake(true);
				}
			}
					
			if (touching){
				addFlag(e_touchingFlag);
			}else{
				clearFlag(e_touchingFlag);
			}
	
			if(wasTouching){
				if(false == touching){
					listener.EndContact(this);
				}
			}else if(touching){
				listener.BeginContact(this);
			}
	
			if(false == hasFlag(e_sensorFlag)){
				listener.PreSolve(this, m_oldManifold);
			}
		}
	
		b2internal virtual function Evaluate() : void{};
		
		private static var s_input:b2TOIInput = new b2TOIInput();
		b2internal function ComputeTOI(sweepA:b2Sweep, sweepB:b2Sweep):Number
		{
			s_input.proxyA.Set(m_fixtureA.GetShape());
			s_input.proxyB.Set(m_fixtureB.GetShape());
			s_input.sweepA = sweepA;
			s_input.sweepB = sweepB;
			s_input.tolerance = b2Settings.b2_linearSlop;
			return b2TimeOfImpact.TimeOfImpact(s_input);
		}
		
		[Inline]
		final public function addFlag(flag:uint):void
		{
			m_flags.addFlag(flag);
		}
		
		[Inline]
		final public function clearFlag(flag:uint):void
		{
			m_flags.clearFlag(flag);
		}
		
		[Inline]
		final public function hasFlag(flag:uint):Boolean
		{
			return m_flags.hasFlagAny(flag);
		}
		
		private const m_flags:FlagSet = new FlagSet();
	
		// World pool and list pointers.
		b2internal var m_prev:b2Contact;
		b2internal var m_next:b2Contact;
	
		// Nodes for connecting bodies.
		b2internal var m_nodeA:b2ContactEdge = new b2ContactEdge();
		b2internal var m_nodeB:b2ContactEdge = new b2ContactEdge();
	
		b2internal var m_fixtureA:b2Fixture;
		b2internal var m_fixtureB:b2Fixture;
	
		b2internal var m_manifold:b2Manifold = new b2Manifold();
		b2internal var m_oldManifold:b2Manifold = new b2Manifold();
		
		b2internal var m_toi:Number;
	}
}