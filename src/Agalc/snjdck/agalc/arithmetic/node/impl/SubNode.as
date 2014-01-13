package snjdck.agalc.arithmetic.node.impl
{
	import snjdck.agalc.arithmetic.node.Node;
	import snjdck.agalc.arithmetic.node.NodeType;
	import snjdck.arithmetic.IScriptContext;
	
	internal class SubNode extends Node
	{
		public function SubNode(type:NodeType, value:String=null)
		{
			super(type, value);
		}
		
		override public function calculate(context:IScriptContext):*
		{
			var leftValue:* = leftChild.calculate(context);
			var rightValue:* = rightChild.calculate(context);
			return leftValue - rightValue;
		}
	}
}