package snjdck.ai.navmesh
{
	import snjdck.ai.astar.IAstarNode;
	
	public class TriAstarNode implements IAstarNode
	{
		private var _x:Number;
		private var _y:Number;
		
		private var _parent:IAstarNode;
		private var _g:Number;
		private var _f:Number;
		
		private var _output:Array;
		
		public var tri:Triangle;
		private var astarTriList:Vector.<TriAstarNode>;
		
		public function TriAstarNode(tri:Triangle, astarTriList:Vector.<TriAstarNode>)
		{
			this.astarTriList = astarTriList;
			this.tri = tri;
			_x = tri.getCenterX();
			_y = tri.getCenterY();
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function get walkable():Boolean
		{
			return true;
		}
		
		public function get parent():IAstarNode
		{
			return _parent;
		}
		
		public function set parent(value:IAstarNode):void
		{
			_parent = value;
		}
		
		public function get g():Number
		{
			return _g;
		}
		
		public function set g(value:Number):void
		{
			_g = value;
		}
		
		public function get f():Number
		{
			return _f;
		}
		
		public function set f(value:Number):void
		{
			_f = value;
		}
		
		public function getOutputNodes():Object
		{
			if(null == _output){
				_output = [];
				_output.push(findNode(tri.triA));
				_output.push(findNode(tri.triB));
				_output.push(findNode(tri.triC));
			}
			return _output;
		}
		
		public function canWalkTo(target:IAstarNode):Boolean
		{
			return true;
		}
		
		public function heuristic(target:IAstarNode):Number
		{
			return Euclidian(this, target);
		}
		
		static private function Euclidian(a:IAstarNode, b:IAstarNode):Number
		{
			var dx:Number = a.x - b.x;
			var dy:Number = a.y - b.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		private function findNode(target:Triangle):TriAstarNode
		{
			if(null == target){
				return null;
			}
			for each(var node:TriAstarNode in astarTriList){
				if(node.tri == target){
					return node;
				}
			}
			return null;
		}
	}
}