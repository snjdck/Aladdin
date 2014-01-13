package snjdck.agalc.arithmetic.node.impl
{
	import snjdck.agalc.arithmetic.node.Node;
	import snjdck.agalc.arithmetic.node.NodeType;
	import snjdck.arithmetic.IScriptContext;
	import snjdck.arithmetic.ReturnError;
	
	internal class DefFuncNode extends Node
	{
		public function DefFuncNode(type:NodeType, value:String=null)
		{
			super(type, value);
		}
		
		override public function calculate(context:IScriptContext):*
		{
			var funcRef:Object = createFunc(context);
			if(value){
				context.newKey(value, funcRef);
			}
			return funcRef;
		}
		
		private function createFunc(context:IScriptContext):Function
		{
			return function():*{
				var childContext:IScriptContext = context.createChildContext();
				
				childContext.newKey("arguments", arguments);
				
				var argNode:Node = leftChild.firstChild;
				var argIndex:int = 0;
				
				while(argNode){
					childContext.newKey(argNode.value, arguments[argIndex++]);
					argNode = argNode.nextSibling;
				}
				
				var result:Object;
				
				try{
					result = rightChild.calculate(childContext);
				}catch(returnError:ReturnError){
					result = returnError.value;
				}
				
				return result;
			};
		}
	}
}