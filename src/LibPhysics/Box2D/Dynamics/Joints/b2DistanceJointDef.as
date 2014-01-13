package Box2D.Dynamics.Joints
{
	import Box2D.Common.b2internal;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	use namespace b2internal;
	
	
	/**
	* Distance joint definition. This requires defining an
	* anchor point on both bodies and the non-zero length of the
	* distance joint. The definition uses local anchor points
	* so that the initial configuration can violate the constraint
	* slightly. This helps when saving and loading a game.
	* @warning Do not use a zero or short length.
	* @see b2DistanceJoint
	*/
	public class b2DistanceJointDef extends b2JointDef
	{
		public function b2DistanceJointDef()
		{
			type = b2Joint.e_distanceJoint;
			//localAnchor1.Set(0.0, 0.0);
			//localAnchor2.Set(0.0, 0.0);
			length = 1.0;
			frequencyHz = 0.0;
			dampingRatio = 0.0;
		}
		
		/**
		* Initialize the bodies, anchors, and length using the world
		* anchors.
		*/
		public function Initialize(bA:b2Body, bB:b2Body, anchorA:b2Vec2, anchorB:b2Vec2):void
		{
			bodyA = bA;
			bodyB = bB;
			localAnchorA.SetV( bodyA.GetLocalPoint(anchorA));
			localAnchorB.SetV( bodyB.GetLocalPoint(anchorB));
			var dX:Number = anchorB.x - anchorA.x;
			var dY:Number = anchorB.y - anchorA.y;
			length = Math.sqrt(dX*dX + dY*dY);
			frequencyHz = 0.0;
			dampingRatio = 0.0;
		}
	
		/**
		* The local anchor point relative to body1's origin.
		*/
		public const localAnchorA:b2Vec2 = new b2Vec2();
	
		/**
		* The local anchor point relative to body2's origin.
		*/
		public const localAnchorB:b2Vec2 = new b2Vec2();
	
		/**
		* The natural length between the anchor points.
		*/
		public var length:Number;
	
		/**
		* The mass-spring-damper frequency in Hertz.
		*/
		public var frequencyHz:Number;
	
		/**
		* The damping ratio. 0 = no damping, 1 = critical damping.
		*/
		public var dampingRatio:Number;
	}
}