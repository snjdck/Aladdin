package snjdck.agalc.arithmetic.node.impl
{
	import snjdck.agalc.arithmetic.node.Node;
	import snjdck.agalc.arithmetic.node.NodeType;

	public class NodeFactory
	{
		static public function Create(nodeType:NodeType, nodeValue:String=null):Node
		{
			switch(nodeType)
			{
				case NodeType.VAR_ID:
					return new VarNode(nodeType, nodeValue);
				case NodeType.OP_ASSIGN:
					return new AssignNode(nodeType, nodeValue);
			}
			return new Node(nodeType, nodeValue);
		}
	}
}