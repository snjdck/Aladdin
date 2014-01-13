package Box2D.Dynamics
{
	/**
	* @private
	*/
	final public class b2TimeStep
	{
		public var dt:Number;			// time step
		public var inv_dt:Number;		// inverse time step (0 if dt == 0).
		public var dtRatio:Number;		// dt * inv_dt0
		public var velocityIterations:int;
		public var positionIterations:int;
		public var warmStarting:Boolean;
		
		public function b2TimeStep()
		{
		}
		
		public function Set(step:b2TimeStep):void
		{
			dt = step.dt;
			inv_dt = step.inv_dt;
			positionIterations = step.positionIterations;
			velocityIterations = step.velocityIterations;
			warmStarting = step.warmStarting;
		}
	}
}