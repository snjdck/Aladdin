package snjdck.ai.behaviortree.controlnodes
{
	import snjdck.ai.behaviortree.CompositeNode;

	public class ParallelNodeAny extends CompositeNode
	{
		public function ParallelNodeAny()
		{
			super();
		}
		
		override public function execute():Boolean
		{
			return execAll() > 0;
		}
	}
}