package Box2D.Dynamics.Controllers
{
	import Box2D.Common.Math.b2Mat22;
	import Box2D.Common.Math.b2Math;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2TimeStep;
	
	/**
	 * Applies top down linear damping to the controlled bodies
	 * The damping is calculated by multiplying velocity by a matrix in local co-ordinates.
	 */
	public class b2TensorDampingController extends b2Controller
	{	
		/**
		 * Tensor to use in damping model
		 */
		public const T:b2Mat22 = new b2Mat22();
		/*Some examples (matrixes in format (row1; row2) )
		(-a 0;0 -a)		Standard isotropic damping with strength a
		(0 a;-a 0)		Electron in fixed field - a force at right angles to velocity with proportional magnitude
		(-a 0;0 -b)		Differing x and y damping. Useful e.g. for top-down wheels.
		*/
		//By the way, tensor in this case just means matrix, don't let the terminology get you down.
		
		/**
		 * Set this to a positive number to clamp the maximum amount of damping done.
		 */
		public var maxTimestep:Number = 0;
		// Typically one wants maxTimestep to be 1/(max eigenvalue of T), so that damping will never cause something to reverse direction
		
		/**
		 * Helper function to set T in a common case
		 */
		public function SetAxisAligned(xDamping:Number, yDamping:Number):void
		{
			T.col1.x = -xDamping;
			T.col1.y = 0;
			T.col2.x = 0;
			T.col2.y = -yDamping;
			
			maxTimestep = (xDamping > 0 || yDamping > 0) ? (1 / Math.max(xDamping, yDamping)) : 0;
		}
		
		public override function Step(step:b2TimeStep):void
		{
			var timestep:Number = step.dt;
			
			if(timestep <= Number.MIN_VALUE){
				return;
			}
			if(maxTimestep < timestep && 0 < maxTimestep){
				timestep = maxTimestep;
			}
			for(var edge:b2ControllerEdge=m_bodyList; edge; edge=edge.nextBody){
				var body:b2Body = edge.body;
				if(false == body.IsAwake()){
					//Sleeping bodies are still - so have no damping
					continue;
				}
				var damping:b2Vec2 = body.GetWorldVector(
						b2Math.MulMV(T,
							body.GetLocalVector(
								body.GetLinearVelocity()
							)
						)
					);
				body.SetLinearVelocity(new b2Vec2(
					body.GetLinearVelocity().x + damping.x * timestep,
					body.GetLinearVelocity().y + damping.y * timestep
				));
			}
		}
	}
}