package Box2D.Dynamics
{
	/** @private */
	public class b2DefaultContactFilter implements b2ContactFilter
	{
		public function ShouldCollide(fixtureA:b2Fixture, fixtureB:b2Fixture):Boolean
		{
			var filter1:b2FilterData = fixtureA.GetFilterData();
			var filter2:b2FilterData = fixtureB.GetFilterData();
			
			if(filter1.groupIndex == filter2.groupIndex && filter1.groupIndex != 0)
			{
				return filter1.groupIndex > 0;
			}
			
			var collideAB:Boolean = (filter1.maskBits & filter2.categoryBits) != 0;
			var collideBA:Boolean = (filter2.maskBits & filter1.categoryBits) != 0;
			
			return collideAB && collideBA;
		}
		
		public function RayCollide(userData:*, fixture:b2Fixture):Boolean
		{
			if(null == userData){
				return true;
			}
			return ShouldCollide(userData, fixture);
		}
	}
}