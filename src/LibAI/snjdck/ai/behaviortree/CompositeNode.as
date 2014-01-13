package snjdck.ai.behaviortree
{
	public class CompositeNode extends Node implements IControlNode
	{
		protected var childList:Array;
		
		public function CompositeNode()
		{
			super();
		}
		
		public function addChildNode(node:Node):void
		{
			
		}
		
		public function execAll():int
		{
			var count:int = 0;
			for each(var node:Node in childList){
				if(node.execute()){
					++count;
				}
			}
			return count;
		}
	}
}