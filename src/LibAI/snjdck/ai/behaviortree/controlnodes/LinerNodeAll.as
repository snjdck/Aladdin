package snjdck.ai.behaviortree.controlnodes
{
	import snjdck.ai.behaviortree.CompositeNode;
	import snjdck.ai.behaviortree.Node;

	public class LinerNodeAll extends CompositeNode
	{
		public function LinerNodeAll()
		{
			super();
		}
		
		override public function execute():Boolean
		{
			for each(var node:Node in childList){
				if(!node.execute()){
					return false;
				}
			}
			return true;
		}
		
	}
}