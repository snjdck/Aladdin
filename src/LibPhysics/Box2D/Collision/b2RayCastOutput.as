/**
 * Returns data on the collision between a ray and a shape.
 */
package Box2D.Collision 
{
	import Box2D.Common.Math.b2Vec2;
	
	public class b2RayCastOutput 
	{
		/**
		 * The normal at the point of collision
		 */
		public const normal:b2Vec2 = new b2Vec2();
		/**
		 * The fraction between p1 and p2 that the collision occurs at
		 */
		public var fraction:Number;
	}
}