package snjdck.agalc.arithmetic.node.impl
{
	import snjdck.agalc.arithmetic.node.Node;
	import snjdck.agalc.arithmetic.node.NodeType;
	import snjdck.arithmetic.IScriptContext;
	
	internal class AssignNode extends Node
	{
		public function AssignNode(type:NodeType, value:String=null)
		{
			super(type, value);
		}
		
		override public function calculate(context:IScriptContext):*
		{
			var rightValue:* = rightChild.calculate(context);
			context.setValue(leftChild.value, rightValue);
			return rightValue;
		}
	}
}