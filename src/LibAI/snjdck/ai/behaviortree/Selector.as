package snjdck.ai.behaviortree
{
	public class Selector extends ComposeNode implements INode
	{
		public function Selector()
		{
		}
		
		public function exec():Boolean
		{
			for each(var node:INode in nodeList){
				if(node.exec()){
					return true;
				}
			}
			return false;
		}
	}
}