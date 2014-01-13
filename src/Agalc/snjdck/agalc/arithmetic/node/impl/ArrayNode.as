package snjdck.agalc.arithmetic.node.impl
{
	import snjdck.agalc.arithmetic.node.Node;
	import snjdck.agalc.arithmetic.node.NodeType;
	import snjdck.arithmetic.IScriptContext;
	
	internal class ArrayNode extends Node
	{
		public function ArrayNode(type:NodeType, value:String=null)
		{
			super(type, value);
		}
		
		override public function calculate(context:IScriptContext):*
		{
			var result:Array = [];
			
			var argNode:Node = firstChild;
			while(argNode){
				result[result.length] = argNode.calculate(context);
				argNode = argNode.nextSibling;
			}
			
			return result;
		}
	}
}