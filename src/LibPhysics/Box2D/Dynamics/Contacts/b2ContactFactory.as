package Box2D.Dynamics.Contacts
{
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Common.b2internal;
	import Box2D.Dynamics.b2Fixture;

	use namespace b2internal;
	
	
	//typedef b2Contact* b2ContactCreateFcn(b2Shape* shape1, b2Shape* shape2, b2BlockAllocator* allocator);
	//typedef void b2ContactDestroyFcn(b2Contact* contact, b2BlockAllocator* allocator);
	
	
	
	/**
	 * This class manages creation and destruction of b2Contact objects.
	 * @private
	 */
	public class b2ContactFactory
	{
		function b2ContactFactory(allocator:*)
		{
			m_allocator = allocator;
			InitializeRegisters();
		}
		
		b2internal function AddType(createFcn:Function, destroyFcn:Function, type1:int, type2:int) : void
		{
			//b2Settings.b2Assert(b2Shape.e_unknownShape < type1 && type1 < b2Shape.e_shapeTypeCount);
			//b2Settings.b2Assert(b2Shape.e_unknownShape < type2 && type2 < b2Shape.e_shapeTypeCount);
			
			m_registers[type1][type2].createFcn = createFcn;
			m_registers[type1][type2].destroyFcn = destroyFcn;
			m_registers[type1][type2].primary = true;
			
			if (type1 != type2)
			{
				m_registers[type2][type1].createFcn = createFcn;
				m_registers[type2][type1].destroyFcn = destroyFcn;
				m_registers[type2][type1].primary = false;
			}
		}
		b2internal function InitializeRegisters():void
		{
			m_registers = new Vector.<Vector.<b2ContactRegister> >(b2Shape.e_shapeTypeCount);
			for (var i:int = 0; i < b2Shape.e_shapeTypeCount; i++){
				m_registers[i] = new Vector.<b2ContactRegister>(b2Shape.e_shapeTypeCount);
				for (var j:int = 0; j < b2Shape.e_shapeTypeCount; j++){
					m_registers[i][j] = new b2ContactRegister();
				}
			}
			
			AddType(b2CircleContact.Create, b2CircleContact.Destroy, b2Shape.e_circleShape, b2Shape.e_circleShape);
			AddType(b2PolyAndCircleContact.Create, b2PolyAndCircleContact.Destroy, b2Shape.e_polygonShape, b2Shape.e_circleShape);
			AddType(b2PolygonContact.Create, b2PolygonContact.Destroy, b2Shape.e_polygonShape, b2Shape.e_polygonShape);
			
			AddType(b2EdgeAndCircleContact.Create, b2EdgeAndCircleContact.Destroy, b2Shape.e_edgeShape, b2Shape.e_circleShape);
			AddType(b2PolyAndEdgeContact.Create, b2PolyAndEdgeContact.Destroy, b2Shape.e_polygonShape, b2Shape.e_edgeShape);
		}
		
		public function Create(fixtureA:b2Fixture, fixtureB:b2Fixture):b2Contact
		{
			var reg:b2ContactRegister = getContactRegister(fixtureA, fixtureB);
			var c:b2Contact;
			
			if(reg.pool){
				// Pop a contact off the pool
				c = reg.pool;
				reg.pool = c.m_next;
				reg.poolCount--;
				c.Reset(fixtureA, fixtureB);
				return c;
			}
			
			var createFcn:Function = reg.createFcn;
			if (createFcn != null)
			{
				c = createFcn(m_allocator);
				if(reg.primary){
					c.Reset(fixtureA, fixtureB);
				}else{
					c.Reset(fixtureB, fixtureA);
				}
				return c;
			}
			
			return null;
		}
		
		public function Destroy(contact:b2Contact):void
		{
			if(contact.m_manifold.m_pointCount > 0)
			{
				contact.m_fixtureA.m_body.SetAwake(true);
				contact.m_fixtureB.m_body.SetAwake(true);
			}

			var reg:b2ContactRegister = getContactRegister(contact.m_fixtureA, contact.m_fixtureB);
			
			reg.poolCount++;
			contact.m_next = reg.pool;
			reg.pool = contact;
			
			reg.destroyFcn(contact, m_allocator);
		}
		
		private function getContactRegister(fixtureA:b2Fixture, fixtureB:b2Fixture):b2ContactRegister
		{
			var type1:int = fixtureA.GetType();
			var type2:int = fixtureB.GetType();
			return m_registers[type1][type2];
		}
		
		private var m_registers:Vector.<Vector.<b2ContactRegister>>;
		private var m_allocator:*;
	}
}