package snjdck.ai.behaviortree.controlnodes
{
	import snjdck.ai.behaviortree.CompositeNode;

	public class ParallelNodeAll extends CompositeNode
	{
		public function ParallelNodeAll()
		{
			super();
		}
		
		override public function execute():Boolean
		{
			return execAll() == childList.length;
		}
	}
}