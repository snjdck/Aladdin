package snjdck.ai.behaviortree
{
	public class Sequence extends ComposeNode implements INode
	{
		public function Sequence()
		{
		}
		
		public function exec():Boolean
		{
			for each(var node:INode in nodeList){
				if(!node.exec()){
					return false;
				}
			}
			return true;
		}
	}
}