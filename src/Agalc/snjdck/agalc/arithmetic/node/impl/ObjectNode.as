package snjdck.agalc.arithmetic.node.impl
{
	import snjdck.agalc.arithmetic.node.Node;
	import snjdck.agalc.arithmetic.node.NodeType;
	import snjdck.arithmetic.IScriptContext;
	
	internal class ObjectNode extends Node
	{
		public function ObjectNode(type:NodeType, value:String=null)
		{
			super(type, value);
		}
		
		override public function calculate(context:IScriptContext):*
		{
			var result:Object = {};
			
			var argNode:Node = firstChild;
			while(argNode){
				var key:Object = argNode.leftChild.calculate(context);
				var value:Object = argNode.rightChild.calculate(context);
				result[key] = value;
				argNode = argNode.nextSibling;
			}
			
			return result;
		}
	}
}