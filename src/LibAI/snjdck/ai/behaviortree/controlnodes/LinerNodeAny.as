package snjdck.ai.behaviortree.controlnodes
{
	import snjdck.ai.behaviortree.CompositeNode;
	import snjdck.ai.behaviortree.Node;

	public class LinerNodeAny extends CompositeNode
	{
		public function LinerNodeAny()
		{
			super();
		}
		
		override public function execute():Boolean
		{
			for each(var node:Node in childList){
				if(node.execute()){
					return true;
				}
			}
			return false;
		}
		
	}
}