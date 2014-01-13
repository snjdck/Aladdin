package snjdck.agalc.arithmetic.rule
{
	import snjdck.agalc.arithmetic.node.Node;
	import snjdck.agalc.arithmetic.node.NodeType;
	import snjdck.agalc.arithmetic.node.impl.NodeFactory;

	internal class LexRule implements ILexRule
	{
		private var pattern:RegExp;
		private var nodeType:NodeType;
		
		public function LexRule(pattern:RegExp, nodeType:NodeType)
		{
			this.pattern = pattern;
			this.nodeType = nodeType;
		}
		
		public function exec(input:String):Node
		{
			var result:Array = pattern.exec(input);
			if(result && (0 == result.index)){
				return NodeFactory.Create(nodeType, result[0]);
			}
			return null;
		}
	}
}