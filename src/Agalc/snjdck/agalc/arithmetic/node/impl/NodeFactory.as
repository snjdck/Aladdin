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
				case NodeType.OP_ADD:
					return new AddNode(nodeType, nodeValue);
				case NodeType.OP_SUB:
					return new SubNode(nodeType, nodeValue);
				case NodeType.OP_MUL:
					return new MulNode(nodeType, nodeValue);
				case NodeType.OP_DIV:
					return new DivNode(nodeType, nodeValue);
				case NodeType.OP_GREATER:
					return new GreaterNode(nodeType, nodeValue);
				case NodeType.OP_GREATER_EQUAL:
					return new GreaterEqualNode(nodeType, nodeValue);
				case NodeType.OP_LESS:
					return new LessNode(nodeType, nodeValue);
				case NodeType.OP_LESS_EQUAL:
					return new LessEqualNode(nodeType, nodeValue);
				case NodeType.OP_EQUAL:
					return new EqualNode(nodeType, nodeValue);
				case NodeType.OP_NOT_EQUAL:
					return new NotEqualNode(nodeType, nodeValue);
				case NodeType.OP_LOGIC_AND:
					return new LogicAndNode(nodeType, nodeValue);
				case NodeType.OP_LOGIC_OR:
					return new LogicOrNode(nodeType, nodeValue);
				case NodeType.STRING:
				case NodeType.NUM:
					return new BaseValueNode(nodeType, nodeValue);
				case NodeType.VAR_ID:
					return new VarNode(nodeType, nodeValue);
			}
			return new Node(nodeType, nodeValue);
		}
	}
}