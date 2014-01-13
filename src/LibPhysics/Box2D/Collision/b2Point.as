package Box2D.Collision
{
	import Box2D.Common.b2internal;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;

	use namespace b2internal;
	
	// This is used for polygon-vs-circle distance.
	/**
	* @private
	*/
	public class b2Point
	{
		public function Support(xf:b2Transform, vX:Number, vY:Number) : b2Vec2
		{
			return p;
		}
	
		public function GetFirstVertex(xf:b2Transform) : b2Vec2
		{
			return p;
		}
		
		public const p:b2Vec2 = new b2Vec2();
	}
}