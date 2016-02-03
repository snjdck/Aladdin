package snjdck.quadtree
{
	import snjdck.g3d.bound.AABB;

	public interface IQuadTreeItem
	{
		function get x():Number;
		function get y():Number;
		function get width():Number;
		function get height():Number;
		function getBound():AABB;
	}
}