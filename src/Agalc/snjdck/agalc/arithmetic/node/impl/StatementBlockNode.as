package snjdck.agalc.arithmetic.node.impl
{
	import snjdck.agalc.arithmetic.node.Node;
	import snjdck.agalc.arithmetic.node.NodeType;
	import snjdck.arithmetic.IScriptContext;
	
	internal class StatementBlockNode extends Node
	{
		public function StatementBlockNode(type:NodeType, value:String=null)
		{
			super(type, value);
		}
		
		override public function calculate(context:IScriptContext):*
		{
			var statement:Node = firstChild;
			while(statement){
				statement.calculate(context);
				statement = statement.nextSibling;
			}
		}
	}
}