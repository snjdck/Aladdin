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
			var result:Array = [];
			var node:Node;
			for each(var rule:LexRule in list){
				node = rule.exec(input);
				if(node != null){
					result.push(node);
				}
			}
			if(result.length <= 0){
				return null;
			}
			if(result.length > 1){
				result.sort(__sortNode);
			}
			return result[0];
		}
		
		static private function __sortNode(left:Node, right:Node):int
		{
			var a:int = left.value.length;
			var b:int = right.value.length;
			if(a > b){
				return -1;
			}
			if(a < b){
				return 1;
			}
			return 0;
		}
	}
}