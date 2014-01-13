package Box2D.Dynamics.Contacts
{
	import Box2D.Common.b2internal;
	use namespace b2internal;
	
	
	/**
	* @private
	*/
	public class b2NullContact extends b2Contact
	{
		public function b2NullContact()
		{
		}
		
		b2internal override function Evaluate():void
		{
		}
	}
}