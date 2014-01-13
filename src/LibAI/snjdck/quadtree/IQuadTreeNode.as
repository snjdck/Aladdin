package snjdck.quadtree
{
	public interface IQuadTreeNode
	{
		function get parent():QuadTree;
		function set parent(value:QuadTree):void;
		
		function get x():Number;
		function get y():Number;
		function get width():Number;
		function get height():Number;
	}
}