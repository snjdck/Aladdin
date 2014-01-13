package snjdck.agalc.arithmetic.node.impl
{
	import snjdck.agalc.arithmetic.node.Node;
	import snjdck.agalc.arithmetic.node.NodeType;
	import snjdck.arithmetic.IScriptContext;
	
	internal class AddNode extends Node
	{
		public function AddNode(type:NodeType, value:String=null)
		{
			super(type, value);
		}
		
		override public function calculate(context:IScriptContext):*
		{
			var leftValue:* = leftChild.calculate(context);
			var rightValue:* = rightChild.calculate(context);
			return leftValue + rightValue;
		}
	}
}