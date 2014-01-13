package Box2D.Dynamics.Contacts
{
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2ContactID;
	import Box2D.Common.Math.b2Vec2;
	
	/**
	* This structure is used to report contact point results.
	*/
	public class b2ContactResult
	{
		/** The first shape */
		public var shape1:b2Shape;
		/** The second shape */
		public var shape2:b2Shape;
		/** Position in world coordinates */
		public const position:b2Vec2 = new b2Vec2();
		/** Points from shape1 to shape2 */
		public const normal:b2Vec2 = new b2Vec2();
		/** The normal impulse applied to body2 */
		public var normalImpulse:Number;
		/** The tangent impulse applied to body2 */
		public var tangentImpulse:Number;
		/** The contact id identifies the features in contact */
		public const id:b2ContactID = new b2ContactID();
		
		public function b2ContactResult()
		{
			
		}
	}
}