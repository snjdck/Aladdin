package snjdck.ai.astar.nodetype
{
	import snjdck.ai.astar.IAstarNode;
	import flash.ds.Array2;

	public class AStarGridNode implements IAstarNode
	{
		static public function CreateGrid(target:Array2):Array2
		{
			var grid:Array2 = new Array2(target.getWidth(), target.getHeight());
			
			for(var y:int=0; y<grid.getHeight(); y++){
				for(var x:int=0; x<grid.getWidth(); x++){
					grid.setValueAt(x, y, new AStarGridNode(x, y, grid, target));
				}
			}
			
			return grid;
		}
		
		private var _x:int;
		private var _y:int;
		
		private var _parent:IAstarNode;
		public var _g:Number;
		public var _f:Number;		//f = g + h, this prop is also used in binHeap
		
		private var grid:Array2;
		private var data:Array2;
		
		public function AStarGridNode(x:int, y:int, grid:Array2, data:Array2)
		{
			this.grid = grid;
			this.data = data;
			this._x = x;
			this._y = y;
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

		private function get costMultiplier():Number
		{
			return walkable ? 1.0 : 10000;
		}
		
		public function get walkable():Boolean
		{
			return 0 == data.getValueAt(x, y);
		}
		
		public function set walkable(value:Boolean):void
		{
			setValue(value?0:1);
		}
		
		public function setValue(value:Object):void
		{
			data.setValueAt(x, y, value);
		}
		
		public function getOutputNodes():Object
		{
			var neighbours:Array = [];
			
			var startX:int = Math.max(0, x - 1);
			var startY:int = Math.max(0, y - 1);
			var endX:int = Math.min(grid.getWidth() - 1, x + 1);
			var endY:int = Math.min(grid.getHeight() - 1, y + 1);
			
			for(var i:int=startX; i<=endX; i++){
				for(var j:int=startY; j<=endY; j++){
					var node:AStarGridNode = grid.getValueAt(i, j);
					if(this != node){
						neighbours.push(node);
					}
				}
			}
			
			return neighbours;
		}
		
		public function toString():String
		{
			return "[Node(x=" + x + ", y=" + y + ")]";
		}
		
		public function canWalkTo(target:IAstarNode):Boolean
		{
			return target.walkable && grid.getValueAt(target.x, y).walkable && grid.getValueAt(x, target.y).walkable;
		}
		
		public function get x():Number
		{
			return _x;
		}

		public function get y():Number
		{
			return _y;
		}
		
		public function heuristic(target:IAstarNode):Number
		{
			return Euclidian(this, target);
		}
	}
}

import snjdck.ai.astar.IAstarNode;

const STRAIGHT_COST:Number = 1.0;
const DIAG_COST:Number = Math.SQRT2;

function Diagonal(a:IAstarNode, b:IAstarNode):Number
{
	var dx:Number = Math.abs(a.x - b.x);
	var dy:Number = Math.abs(a.y - b.y);
	var diag:Number = Math.min(dx, dy);
	return DIAG_COST * diag + STRAIGHT_COST * (dx + dy - 2 * diag);
}

function Euclidian(a:IAstarNode, b:IAstarNode):Number
{
	var dx:Number = a.x - b.x;
	var dy:Number = a.y - b.y;
	return Math.sqrt(dx * dx + dy * dy) * STRAIGHT_COST;
}

function Manhattan(a:IAstarNode, b:IAstarNode):Number
{
	return STRAIGHT_COST * ( Math.abs(a.x - b.x) + Math.abs(a.y - b.y) );
}