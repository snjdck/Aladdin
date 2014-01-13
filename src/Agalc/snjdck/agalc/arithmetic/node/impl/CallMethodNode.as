package snjdck.agalc.arithmetic.node.impl
{
	import lambda.apply;
	
	import snjdck.agalc.arithmetic.node.Node;
	import snjdck.agalc.arithmetic.node.NodeType;
	import snjdck.arithmetic.IScriptContext;
	
	internal class CallMethodNode extends Node
	{
		public function CallMethodNode(type:NodeType, value:String=null)
		{
			super(type, value);
		}
		
		override public function calculate(context:IScriptContext):*
		{
			var leftValue:* = leftChild.calculate(context);
			var rightValue:* = rightChild.calculate(context);
			return lambda.apply(leftValue, rightValue);
		}
	}
}