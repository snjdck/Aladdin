package snjdck.agalc.arithmetic.node
{
	public interface INodeList
	{
		function add(node:Node):void;
		
		function first():Node;
		function next():Node;
		
		function expect(nodeType:NodeType):Boolean;
		function accept(nodeType:NodeType):Node;
		function matchAny(nodeTypes:Array):Boolean;
	}
}