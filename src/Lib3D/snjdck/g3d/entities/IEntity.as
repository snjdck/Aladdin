package snjdck.g3d.entities
{
	import snjdck.g3d.bounds.AABB;

	public interface IEntity
	{
		function get worldBound():AABB;
	}
}