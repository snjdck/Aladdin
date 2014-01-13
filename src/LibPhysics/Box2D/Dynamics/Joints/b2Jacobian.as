package Box2D.Dynamics.Joints
{
	import Box2D.Common.Math.b2Vec2;
	
	/**
	* @private
	*/
	public class b2Jacobian
	{
		public const linearA:b2Vec2 = new b2Vec2();
		public var angularA:Number;
		
		public const linearB:b2Vec2 = new b2Vec2();
		public var angularB:Number;
		
		public function b2Jacobian()
		{
			SetZero();
		}
	
		public function SetZero():void
		{
			linearA.SetZero();
			angularA = 0.0;
			
			linearB.SetZero();
			angularB = 0.0;
		}
		
		public function Set(x1:b2Vec2, a1:Number, x2:b2Vec2, a2:Number):void
		{
			linearA.SetV(x1);
			angularA = a1;
			
			linearB.SetV(x2);
			angularB = a2;
		}
		
		public function Compute(x1:b2Vec2, a1:Number, x2:b2Vec2, a2:Number):Number
		{
			//return b2Math.b2Dot(linearA, x1) + angularA * a1 + b2Math.b2Dot(linearV, x2) + angularV * a2;
			return (linearA.x*x1.x + linearA.y*x1.y) + angularA * a1 + (linearB.x*x2.x + linearB.y*x2.y) + angularB * a2;
		}
	}
}