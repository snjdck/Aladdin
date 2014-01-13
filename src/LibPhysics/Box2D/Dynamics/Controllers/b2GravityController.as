package Box2D.Dynamics.Controllers
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2TimeStep;
	
	/**
	 * Applies simplified gravity between every pair of bodies 
	 */
	public class b2GravityController extends b2Controller
	{	
		/**
		 * Specifies the strength of the gravitiation force
		 */
		static public const G:Number = 1;
		/**
		 * If true, gravity is proportional to r^-2, otherwise r^-1
		 */
		static public const invSqr:Boolean = true;
		
		public override function Step(step:b2TimeStep):void
		{
			var edge1:b2ControllerEdge;
			var edge2:b2ControllerEdge;
			
			var body1:b2Body;
			var body2:b2Body;
			
			var p1:b2Vec2;
			var p2:b2Vec2;
			
			var mass1:Number = 0;
			var dx:Number = 0;
			var dy:Number = 0;
			var r2:Number = 0;
			var f:b2Vec2;
			
			if(invSqr){
				for(edge1=m_bodyList; edge1; edge1=edge1.nextBody){
					body1 = edge1.body;
					p1 = body1.GetWorldCenter();
					mass1 = body1.GetMass();
					for(edge2=m_bodyList; edge2!=edge1; edge2=edge2.nextBody){
						body2 = edge2.body;
						p2 = body2.GetWorldCenter()
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						r2 = dx*dx+dy*dy;
						if(r2<Number.MIN_VALUE)
							continue;
						f = new b2Vec2(dx,dy);
						f.Multiply(G / r2 / Math.sqrt(r2) * mass1* body2.GetMass());
						if(body1.IsAwake())
							body1.ApplyForce(f,p1);
						f.Multiply(-1);
						if(body2.IsAwake())
							body2.ApplyForce(f,p2);
					}
				}
			}else{
				for(edge1=m_bodyList; edge1; edge1=edge1.nextBody){
					body1 = edge1.body;
					p1 = body1.GetWorldCenter();
					mass1 = body1.GetMass();
					for(edge2=m_bodyList; edge2!=edge1; edge2=edge2.nextBody){
						body2 = edge2.body;
						p2 = body2.GetWorldCenter()
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						r2 = dx*dx+dy*dy;
						if(r2<Number.MIN_VALUE)
							continue;
						f = new b2Vec2(dx,dy);
						f.Multiply(G / r2 * mass1 * body2.GetMass());
						if(body1.IsAwake())
							body1.ApplyForce(f,p1);
						f.Multiply(-1);
						if(body2.IsAwake())
							body2.ApplyForce(f,p2);
					}
				}
			}
		}
	}
}