package snjdck.g3d.entities
{
	import snjdck.g3d.bounds.IBound;

	public interface IEntity
	{
		function get worldBound():IBound;
	}
}