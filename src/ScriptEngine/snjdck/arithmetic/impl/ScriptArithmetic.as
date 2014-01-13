package snjdck.arithmetic.impl
{
	import snjdck.agalc.arithmetic.Arithmetic;
	import snjdck.agalc.arithmetic.Lexer;
	import snjdck.agalc.arithmetic.node.Node;
	import snjdck.agalc.arithmetic.node.NodeType;
	import snjdck.agalc.arithmetic.node.impl.NodeFactory;
	import snjdck.agalc.arithmetic.rule.LexRuleFactory;
	
	public class ScriptArithmetic extends Arithmetic
	{
		public function ScriptArithmetic()
		{
			super(LexRuleFactory.CreateScriptArithmeticRuleList());
		}
		
		private function readStatement():Node
		{
			var node:Node;
			switch(nodeList.first().type)
			{
				case NodeType.KEYWORD_WHILE:
					node = readWhileStatement();
					break;
				case NodeType.KEYWORD_IF:
					node = readIfStatement();
					break;
				case NodeType.KEYWORD_VAR:
					node = readVarStatement();
					break;
				case NodeType.KEYWORD_FUNC:
					node = readFuncStatement();
					break;
				case NodeType.KEYWORD_RETURN:
					node = readReturnStatement();
					break;
				default:
					node = expression();
			}
			return node;
		}
		
		private function readReturnStatement():Node
		{
			var op:Node = nodeList.next();
			var result:Node = expression();
			return calcute(result, op);
		}
		
		private function readVarStatement():Node
		{
			var op:Node = nodeList.next();
			var varName:Node = nodeList.accept(NodeType.VAR_ID);
			var varValue:Node;
			if(nodeList.expect(NodeType.OP_ASSIGN)){
				nodeList.accept(NodeType.OP_ASSIGN);
				varValue = expression();
			}
			return calcute(varName, op, varValue);
		}
		
		private function readFuncStatement():Node
		{
			var op:Node = nodeList.next();
			op = NodeFactory.Create(op.type, (nodeList.expect(NodeType.VAR_ID) ? nodeList.accept(NodeType.VAR_ID).value : null));
			
			var paramList:Node = readValueList(NodeType.PARENTHESES_LEFT, NodeType.PARENTHESES_RIGHT);
			var funcBody:Node = readStatementBlockWithBraces();
			return calcute(
				calcute(paramList, NodeFactory.Create(NodeType.ARRAY)),
				op,
				funcBody
			);
		}
		
		private function readWhileStatement():Node
		{
			var op:Node = nodeList.next();
			var condition:Node = expression();
			var block:Node = readStatementBlockWithBraces();
			return calcute(condition, op, block);
		}
		
		private function readIfStatement():Node
		{
			var op:Node = nodeList.next();
			var condition:Node = expression();
			var block:Node = readStatementBlockWithBraces();
			while(nodeList.expect(NodeType.KEYWORD_ELSE)){
				nodeList.accept(NodeType.KEYWORD_ELSE);
				readStatementBlockWithBraces();
			}
			return calcute(condition, op, block);
		}
		
		private function readStatementBlockWithBraces():Node
		{
			nodeList.accept(NodeType.BRACES_LEFT);
			var node:Node = readStatementBlock(NodeType.BRACES_RIGHT);
			nodeList.accept(NodeType.BRACES_RIGHT);
			return node;
		}
		
		private function readStatementBlock(endNodeType:NodeType):Node
		{
			var firstNode:Node;
			if(!nodeList.expect(endNodeType))
			{
				firstNode = readStatement();
				var currentNode:Node = firstNode;
				while(!nodeList.expect(endNodeType))
				{
//					nodeList.accept(NodeType.COMMA);
					currentNode.nextSibling = readStatement();
					currentNode = currentNode.nextSibling;
				}
			}
			return calcute(firstNode, NodeFactory.Create(NodeType.STEMENT_BLOCK));
		}
		
		public function parse(source:String):Node
		{
			Lexer.Parse(source, ruleList, nodeList);
			
			var node:Node = readStatementBlock(NodeType.EOF);
			nodeList.accept(NodeType.EOF);
			
			return calcute(
				calcute(
					NodeFactory.Create(NodeType.ARRAY),
					NodeFactory.Create(NodeType.KEYWORD_FUNC),
					node
				),
				NodeFactory.Create(NodeType.CALL_METHOD),
				NodeFactory.Create(NodeType.ARRAY)
			);
		}
		
		override public function expression():Node
		{
			return matchRight(logicOr, [NodeType.OP_ASSIGN]);
		}
		
		private function logicOr():Node{
			return matchLeft(logicAnd, [NodeType.OP_LOGIC_OR]);
		}
		
		private function logicAnd():Node{
			return matchLeft(equ, [NodeType.OP_LOGIC_AND]);
		}
		
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
			var a:Node = val();
			
			var prop:Node;
			var loopFlag:Boolean = true;
			do{
				switch(nodeList.first().type)
				{
					case NodeType.OP_DOT:
						nodeList.accept(NodeType.OP_DOT);
						prop = nodeList.accept(NodeType.VAR_ID);
						prop.type = NodeType.STRING;
						a = calcute(a, NodeFactory.Create(NodeType.GET_PROP), prop);
						break;
					case NodeType.PARENTHESES_LEFT:
						prop = calcute(readValueList(NodeType.PARENTHESES_LEFT, NodeType.PARENTHESES_RIGHT), NodeFactory.Create(NodeType.ARRAY));
						a = calcute(a, NodeFactory.Create(NodeType.CALL_METHOD), prop);
						break;
					case NodeType.BRACKETS_LEFT:
						nodeList.accept(NodeType.BRACKETS_LEFT);
						prop = expression();
						nodeList.accept(NodeType.BRACKETS_RIGHT);
						a = calcute(a, NodeFactory.Create(NodeType.GET_PROP), prop);
						break;
					default:
						loopFlag = false;
				}
			}while(loopFlag);
			
			return a;
		}
		
		private function val():Node
		{
			var result:Node;
			switch(nodeList.first().type)
			{
				case NodeType.VAR_ID:
				case NodeType.REG_ID:
				case NodeType.NUM:
				case NodeType.STRING:
					result = nodeList.next();
					break;
				case NodeType.PARENTHESES_LEFT:
					nodeList.accept(NodeType.PARENTHESES_LEFT);
					result = expression();
					nodeList.accept(NodeType.PARENTHESES_RIGHT);
					break;
				case NodeType.BRACKETS_LEFT:
					result = calcute(readValueList(NodeType.BRACKETS_LEFT, NodeType.BRACKETS_RIGHT), NodeFactory.Create(NodeType.ARRAY));
					break;
				case NodeType.BRACES_LEFT:
					result = calcute(readValueList(NodeType.BRACES_LEFT, NodeType.BRACES_RIGHT, readKeyValue), NodeFactory.Create(NodeType.OBJECT));
					break;
			}
			if(null == result){
				throw new Error("error input!");
			}
			return result;
		}
	}
}