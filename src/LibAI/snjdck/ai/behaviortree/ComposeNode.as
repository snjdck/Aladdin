package snjdck.ai.behaviortree
{
	internal class ComposeNode
	{
		protected var nodeList:Vector.<INode>;
		
		public function ComposeNode()
		{
			nodeList = new Vector.<INode>();
		}
		
		public function addChild(node:INode):void
		{
			nodeList.push(node);
		}
	}
}