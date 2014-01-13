package Box2D.Dynamics
{
	/**
	* Implement this class to provide collision filtering. In other words, you can implement
	* this class if you want finer control over contact creation.
	*/
	public interface b2ContactFilter
	{
		/**
		* Return true if contact calculations should be performed between these two fixtures.
		* @warning for performance reasons this is only called when the AABBs begin to overlap.
		*/
		function ShouldCollide(fixtureA:b2Fixture, fixtureB:b2Fixture):Boolean;
		
		/**
		* Return true if the given fixture should be considered for ray intersection.
		* By default, userData is cast as a b2Fixture and collision is resolved according to ShouldCollide
		* @see ShouldCollide()
		* @see b2World#Raycast
		* @param userData	arbitrary data passed from Raycast or RaycastOne
		* @param fixture		the fixture that we are testing for filtering
		* @return a Boolean, with a value of false indicating that this fixture should be ignored.
		*/
		function RayCollide(userData:*, fixture:b2Fixture):Boolean;
	}
}