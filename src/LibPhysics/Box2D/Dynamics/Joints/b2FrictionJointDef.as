package Box2D.Dynamics.Joints
{
	import Box2D.Common.b2internal;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;

	use namespace b2internal;
	
	
	/**
	 * Friction joint defintion
	 * @see b2FrictionJoint
	 */
	public class b2FrictionJointDef extends b2JointDef
	{
		public function b2FrictionJointDef()
		{
			type = b2Joint.e_frictionJoint;
			maxForce = 0.0;
			maxTorque = 0.0;
		}
		
		/**
		 * Initialize the bodies, anchors, axis, and reference angle using the world
		 * anchor and world axis.
		 */
		public function Initialize(bA:b2Body, bB:b2Body, anchor:b2Vec2):void
		{
			bodyA = bA;
			bodyB = bB;
			localAnchorA.SetV( bodyA.GetLocalPoint(anchor));
			localAnchorB.SetV( bodyB.GetLocalPoint(anchor));
		}
	
		/**
		* The local anchor point relative to bodyA's origin.
		*/
		public const localAnchorA:b2Vec2 = new b2Vec2();
	
		/**
		* The local anchor point relative to bodyB's origin.
		*/
		public const localAnchorB:b2Vec2 = new b2Vec2();
	
		/**
		 * The maximun force in N.
		 */
		public var maxForce:Number;
		
		/**
		 * The maximun friction torque in N-m
		 */
		public var maxTorque:Number;
	}

}