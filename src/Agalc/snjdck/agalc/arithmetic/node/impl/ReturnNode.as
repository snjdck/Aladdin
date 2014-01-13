package snjdck.agalc.arithmetic.node.impl
{
	import snjdck.agalc.arithmetic.node.Node;
	import snjdck.agalc.arithmetic.node.NodeType;
	import snjdck.arithmetic.IScriptContext;
	import snjdck.arithmetic.ReturnError;
	
	internal class ReturnNode extends Node
	{
		public function ReturnNode(type:NodeType, value:String=null)
		{
			super(type, value);
		}
		
		override public function calculate(context:IScriptContext):*
		{
			var value:Object = firstChild.calculate(context);
			throw new ReturnError(value);
		}
	}
}