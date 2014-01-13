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
				case NodeType.GET_PROP:
					return new GetPropNode(nodeType, nodeValue);
				case NodeType.CALL_METHOD:
					return new CallMethodNode(nodeType, nodeValue);
				case NodeType.OP_ASSIGN:
					return new AssignNode(nodeType, nodeValue);
				case NodeType.STRING:
				case NodeType.NUM:
					return new BaseValueNode(nodeType, nodeValue);
				case NodeType.VAR_ID:
					return new VarNode(nodeType, nodeValue);
				case NodeType.ARRAY:
					return new ArrayNode(nodeType, nodeValue);
				case NodeType.OBJECT:
					return new ObjectNode(nodeType, nodeValue);
				case NodeType.KEYWORD_WHILE:
					return new WhileNode(nodeType, nodeValue);
				case NodeType.KEYWORD_IF:
					return new IfNode(nodeType, nodeValue);
				case NodeType.STEMENT_BLOCK:
					return new StatementBlockNode(nodeType, nodeValue);
				case NodeType.KEYWORD_VAR:
					return new DefVarNode(nodeType, nodeValue);
				case NodeType.KEYWORD_FUNC:
					return new DefFuncNode(nodeType, nodeValue);
				case NodeType.KEYWORD_RETURN:
					return new ReturnNode(nodeType, nodeValue);
			}
			return new Node(nodeType, nodeValue);
		}
	}
}