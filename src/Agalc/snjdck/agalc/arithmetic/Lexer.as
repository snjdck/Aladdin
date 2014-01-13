package snjdck.agalc.arithmetic
{
	import snjdck.agalc.arithmetic.node.INodeList;
	import snjdck.agalc.arithmetic.node.Node;
	import snjdck.agalc.arithmetic.node.NodeType;
	import snjdck.agalc.arithmetic.node.impl.NodeFactory;
	import snjdck.agalc.arithmetic.rule.ILexRule;

	final public class Lexer
	{
		static public function Parse(input:String, ruleList:ILexRule, outputNodeList:INodeList):void
		{
			var index:int = 0;
			
			while(index < input.length)
			{
				var char:String = input.charAt(index);
				
				if(isBlank(char)){
					index++;
					continue;
				}
				
				var node:Node = ruleList.exec(input.slice(index));
				if(null == node){
					node = NodeFactory.Create(NodeType.UNKNOW, char);
				}
				outputNodeList.add(node);
				
				index += node.value.length;
			}
			
			outputNodeList.add(NodeFactory.Create(NodeType.EOF));
		}
		
		static private function isBlank(char:String):Boolean
		{
			switch(char)
			{
				case " ":
				case "\t":
				case "\r":
				case "\n":
					return true;
			}
			return false;
		}
	}
}