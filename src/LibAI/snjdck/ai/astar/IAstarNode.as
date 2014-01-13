package snjdck.ai.astar
{
	public interface IAstarNode
	{
		function get x():Number;
		function get y():Number;
		function get walkable():Boolean;
		
		function get parent():IAstarNode;
		function set parent(value:IAstarNode):void;
		
		function get g():Number;
		function set g(value:Number):void;
		
		function get f():Number;
		function set f(value:Number):void;
		
		/** Array or Vector */
		function getOutputNodes():Object;
		function canWalkTo(target:IAstarNode):Boolean;
		function heuristic(target:IAstarNode):Number;
	}
}