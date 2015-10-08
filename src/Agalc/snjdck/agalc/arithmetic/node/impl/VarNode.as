package snjdck.agalc.arithmetic.node.impl
{
	import snjdck.agalc.arithmetic.TempRegFactory;
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
		
		override public function visit(output:Array, regFactory:TempRegFactory):String
		{
			var a:String = leftChild.visit(output, regFactory);
			var b:String;
			if(rightChild != null){
				b = rightChild.visit(output, regFactory);
			}
			var c:String = getC(a, b, regFactory);
			output.push([value, c, a, b]);
			return c;
		}
	}
}