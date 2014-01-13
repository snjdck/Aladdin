package snjdck.agalc
{
	import snjdck.agalc.arithmetic.Arithmetic;
	import snjdck.agalc.arithmetic.Lexer;
	import snjdck.agalc.arithmetic.node.Node;
	import snjdck.agalc.arithmetic.node.NodeType;
	import snjdck.agalc.arithmetic.node.impl.NodeFactory;
	import snjdck.agalc.arithmetic.rule.LexRuleFactory;

	public class AgalArithmetic extends Arithmetic
	{
		public function AgalArithmetic()
		{
			super(LexRuleFactory.CreateShaderArithmeticRuleList());
		}
		
		public function parse(source:String):Node
		{
			Lexer.Parse(source, ruleList, nodeList);
			var node:Node = equ();
			nodeList.accept(NodeType.EOF);
			return node;
		}
		/*
		private function assign():Node
		{
			return matchRight(equ, [NodeType.OP_ASSIGN]);
		}
		*/
		private function equ():Node{
			return matchLeft(com, [NodeType.OP_EQUAL, NodeType.OP_NOT_EQUAL]);
		}
		
		private function com():Node{
			return matchLeft(e, [NodeType.OP_GREATER, NodeType.OP_GREATER_EQUAL, NodeType.OP_LESS, NodeType.OP_LESS_EQUAL]);
		}
		
		private function e():Node{
			return matchLeft(t, [NodeType.OP_ADD, NodeType.OP_SUB]);
		}
		
		private function t():Node{
			return matchLeft(unitary, [NodeType.OP_MUL, NodeType.OP_DIV]);
		}
		
		private function unitary():Node{
			if(nodeList.expect(NodeType.OP_SUB)){
				return calcute(NodeFactory.Create(NodeType.NUM, "0"), nodeList.next(), unitary());
			}
			if(nodeList.expect(NodeType.OP_ADD)){
				nodeList.next();
				return unitary();
			}
			return f();
		}
		
		private function f():Node{
			return matchRight(val, [NodeType.OP_POW]);
		}
		
		private function val():Node
		{
			switch(nodeList.first().type){
				case NodeType.REG_ID:
				case NodeType.NUM:
					return nodeList.next();
				case NodeType.PARENTHESES_LEFT:
					nodeList.accept(NodeType.PARENTHESES_LEFT);
					var val:Node = equ();
					nodeList.accept(NodeType.PARENTHESES_RIGHT);
					return val;
				default:
					throw new Error("error input!");
			}
		}
	}
}