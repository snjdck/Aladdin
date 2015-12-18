package snjdck.agalc.arithmetic
{
	import snjdck.agalc.arithmetic.node.INodeList;
	import snjdck.agalc.arithmetic.node.Node;
	import snjdck.agalc.arithmetic.node.NodeList;
	import snjdck.agalc.arithmetic.node.NodeType;
	import snjdck.agalc.arithmetic.node.impl.NodeFactory;
	import snjdck.agalc.arithmetic.rule.ILexRule;

	public class Arithmetic implements IArithmetic
	{
		protected const nodeList:INodeList = new NodeList();
		private var ruleList:ILexRule;
		
		public function Arithmetic(ruleList:ILexRule)
		{
			this.ruleList = ruleList;
		}
		
		public function parse(source:String):Node
		{
			Lexer.Parse(source, ruleList, nodeList);
			var node:Node = expression();
			nodeList.accept(NodeType.EOF);
			return node;
		}
		
		virtual public function expression():Node
		{
			return null;
		}
		
		final protected function matchLeft(nextNode:Function, opList:Array):Node
		{
			var a:Node = nextNode();
			while(nodeList.matchAny(opList)){
				a = calcute(a, nodeList.next(), nextNode());
			}
			return a;
		}
		
		final protected function matchRight(nextNode:Function, opList:Array):Node
		{
			var a:Node = nextNode();
			if(nodeList.matchAny(opList)){
				return calcute(a, nodeList.next(), matchRight(nextNode, opList));
			}
			return a;
		}
		
		final protected function calcute(a:Node, op:Node, b:Node):Node
		{
			op.firstChild = a;
			if(b){
				if(a.nextSibling){
					throw new Error("a.nextSibling is not null!");
				}
				a.nextSibling = b;
			}
			return op;
		}
		
		final protected function readValueList(endNodeType:NodeType, readHandler:Function):Node
		{
			if(nodeList.expect(endNodeType)){
				return null;
			}
			var firstNode:Node = readHandler();
			var currentNode:Node = firstNode;
			while(!nodeList.expect(endNodeType))
			{
				nodeList.accept(NodeType.COMMA);
				currentNode.nextSibling = readHandler();
				currentNode = currentNode.nextSibling;
			}
			return firstNode;
		}
		
		final protected function readKeyValue():Node
		{
			var key:Node = nodeList.accept(NodeType.STRING);
			nodeList.accept(NodeType.COLON);
			return calcute(key, NodeFactory.Create(NodeType.KEY_VALUE), expression());
		}
	}
}