package snjdck.agalc.arithmetic.rule
{
	import snjdck.agalc.arithmetic.node.Node;
	import snjdck.agalc.arithmetic.node.NodeType;

	internal class LexRuleList implements ILexRule
	{
		private var list:Vector.<LexRule>;
		
		public function LexRuleList()
		{
			list = new <LexRule>[];
		}
		
		public function addRule(pattern:RegExp, nodeType:NodeType):void
		{
			list.push(new LexRule(pattern, nodeType));
		}
		
		public function exec(input:String):Node
		{
			for each(var rule:LexRule in list){
				var node:Node = rule.exec(input);
				if(node){
					return node;
				}
			}
			return null;
		}
	}
}