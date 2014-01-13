package snjdck.agalc.arithmetic.node.impl
{
	import snjdck.agalc.arithmetic.node.Node;
	import snjdck.agalc.arithmetic.node.NodeType;
	import snjdck.arithmetic.IScriptContext;
	
	internal class VarNode extends Node
	{
		public function VarNode(type:NodeType, value:String=null)
		{
			super(type, value);
		}
		
		override public function calculate(context:IScriptContext):*
		{
			return context.getValue(value);
		}
	}
}