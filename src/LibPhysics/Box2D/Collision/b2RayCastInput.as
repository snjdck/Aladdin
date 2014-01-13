﻿/**
 * Specifies a segment for use with RayCast functions.
 */
package Box2D.Collision 
{
	import Box2D.Common.Math.b2Vec2;
	
	public class b2RayCastInput 
	{
		function b2RayCastInput(p1:b2Vec2 = null, p2:b2Vec2 = null, maxFraction:Number = 1)
		{
			if (p1)
				this.p1.SetV(p1);
			if (p2)
				this.p2.SetV(p2);
			this.maxFraction = maxFraction;
		}
		/**
		 * The start point of the ray
		 */
		public var p1:b2Vec2 = new b2Vec2();
		/**
		 * The end point of the ray
		 */
		public var p2:b2Vec2 = new b2Vec2();
		/**
		 * Truncate the ray to reach up to this fraction from p1 to p2
		 */
		public var maxFraction:Number;
	}
}