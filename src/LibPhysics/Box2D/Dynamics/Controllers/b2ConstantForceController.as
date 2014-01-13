package Box2D.Dynamics.Controllers
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2TimeStep;
	
	/**
	 * Applies a force every frame
	 */
	public class b2ConstantForceController extends b2Controller
	{	
		/**
		 * The force to apply
		 */
		public const F:b2Vec2 = new b2Vec2(0, 0);
		
		public override function Step(step:b2TimeStep):void
		{
			for(var edge:b2ControllerEdge=m_bodyList; edge; edge=edge.nextBody){
				var body:b2Body = edge.body;
				if(false == body.IsAwake()){
					continue;
				}
				body.ApplyForce(F, body.GetWorldCenter());
			}
		}
	}
}