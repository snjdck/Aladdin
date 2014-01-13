package Box2D.Dynamics
{
	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	/** @private */
	public class b2DefaultContactListener implements b2ContactListener
	{
		public function b2DefaultContactListener()
		{
		}
		
		public function BeginContact(contact:b2Contact):void
		{
		}
		
		public function EndContact(contact:b2Contact):void
		{
		}
		
		public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void
		{
		}
		
		public function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void
		{
		}
	}
}