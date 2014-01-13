package Box2D.Dynamics.Controllers 
{
	import Box2D.Common.b2internal;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2TimeStep;
	import Box2D.Dynamics.b2World;

	use namespace b2internal;
		
	/**
	 * Base class for controllers. Controllers are a convience for encapsulating common
	 * per-step functionality.
	 */
	public class b2Controller
	{
		public function Step(step:b2TimeStep):void
		{
		}
			
		public function Draw(debugDraw:b2DebugDraw):void
		{
		}
		
		final public function AddBody(body:b2Body):void
		{
			var edge:b2ControllerEdge = new b2ControllerEdge();
			edge.controller = this;
			edge.body = body;
			//
			edge.nextBody = m_bodyList;
			edge.prevBody = null;
			m_bodyList = edge;
			if (edge.nextBody){
				edge.nextBody.prevBody = edge;
			}
			m_bodyCount++;
			//
			edge.nextController = body.m_controllerList;
			edge.prevController = null;
			body.m_controllerList = edge;
			if (edge.nextController){
				edge.nextController.prevController = edge;
			}
			body.m_controllerCount++;
		}
		
		final public function RemoveBody(body:b2Body):void
		{
			var edge:b2ControllerEdge = body.m_controllerList;
			while(edge && edge.controller != this){
				edge = edge.nextController;
			}
			
			if(edge.prevBody){
				edge.prevBody.nextBody = edge.nextBody;
			}
			if(edge.nextBody){
				edge.nextBody.prevBody = edge.prevBody;
			}
			if(edge.nextController){
				edge.nextController.prevController = edge.prevController;
			}
			if(edge.prevController){
				edge.prevController.nextController = edge.nextController;
			}
			if(m_bodyList == edge){
				m_bodyList = edge.nextBody;
			}
			if(body.m_controllerList == edge){
				body.m_controllerList = edge.nextController;
			}
			body.m_controllerCount--;
			m_bodyCount--;
		}
		
		final public function Clear():void
		{
			while(m_bodyList){
				RemoveBody(m_bodyList.body);
			}
		}
		
		public function GetNext():b2Controller
		{
			return m_next;
		}
		
		public function GetWorld():b2World
		{
			return m_world;
		}
		
		public function GetBodyList():b2ControllerEdge
		{
			return m_bodyList;
		}
		
		b2internal var m_next:b2Controller;
		b2internal var m_prev:b2Controller;
		
		protected var m_bodyList:b2ControllerEdge;
		private var m_bodyCount:int;
		
		b2internal var m_world:b2World;
	}
}