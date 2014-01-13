package Box2D.Dynamics.Controllers
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2TimeStep;
	
	/**
	 * Applies an acceleration every frame, like gravity
	 */
	public class b2ConstantAccelController extends b2Controller
	{	
		/**
		 * The acceleration to apply
		 */
		public const A:b2Vec2 = new b2Vec2(0, 0);
		
		public override function Step(step:b2TimeStep):void
		{
			var smallA:b2Vec2 = new b2Vec2(A.x*step.dt,A.y*step.dt);
			for(var edge:b2ControllerEdge=m_bodyList; edge; edge=edge.nextBody){
				var body:b2Body = edge.body;
				if(false == body.IsAwake()){
					continue;
				}
				//Am being lazy here
				body.SetLinearVelocity(new b2Vec2(
					body.GetLinearVelocity().x + smallA.x,
					body.GetLinearVelocity().y + smallA.y
				));
			}
		}
	}

}