package snjdck.agalc.arithmetic.node
{
	import array.has;
	import array.push;

	public class NodeList implements INodeList
	{
		private var list:Vector.<Node>;
		
		public function NodeList()
		{
			list = new <Node>[];
		}
		
		public function add(node:Node):void
		{
			array.push(list, node);
		}
		
		public function first():Node
		{
			return list[0];
		}
		
		public function next():Node
		{
			return list.shift();
		}
		
		public function expect(nodeType:NodeType):Boolean
		{
			return first().type == nodeType;
		}
		
		public function accept(nodeType:NodeType):Node
		{
			if(expect(nodeType) == false){
				throw new Error("this nodeType is not the expect one!");
			}
			return next();
		}
		
		public function matchAny(nodeTypes:Array):Boolean
		{
			return array.has(nodeTypes, first().type);
		}
		
		public function toString():String
		{
			return list.toString();
		}
	}
}