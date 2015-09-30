package snjdck.agalc.arithmetic.node.impl
{
	import snjdck.agalc.arithmetic.TempRegFactory;
	import snjdck.agalc.arithmetic.node.Node;
	import snjdck.agalc.arithmetic.node.NodeType;
	
	internal class AssignNode extends Node
	{
		public function AssignNode(type:NodeType, value:String=null)
		{
			super(type, value);
		}
		
		override public function visit(output:Array, regFactory:TempRegFactory):String
		{
			var a:String = leftChild.visit(output, regFactory);
			var b:String = rightChild.visit(output, regFactory);
			if(value.length > 1){
				output.push([value.slice(0, -1), a, a, b]);
			}else if(regFactory.isTempReg(b)){
				output[output.length-1][1] = a;
			}else{
				output.push([value, a, b]);
			}
			return null;
		}
	}
}