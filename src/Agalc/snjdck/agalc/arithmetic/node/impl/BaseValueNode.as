package snjdck.agalc.arithmetic.node.impl
{
	import snjdck.agalc.arithmetic.node.Node;
	import snjdck.agalc.arithmetic.node.NodeType;
	import snjdck.arithmetic.IScriptContext;
	
	internal class BaseValueNode extends Node
	{
		public function BaseValueNode(type:NodeType, value:String=null)
		{
			super(type, value);
		}
		
		override public function calculate(context:IScriptContext):*
		{
			return realValue;
		}
	}
}