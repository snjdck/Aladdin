package snjdck.g3d.cameras
{
	import snjdck.g3d.bounds.AABB;
	import snjdck.g3d.bounds.IBound;

	public interface IViewFrustum
	{
		function classify(bound:IBound):int;
		function classifyBox(bound:AABB):int;
		
		function hitTest(bound:IBound):Boolean;
		function hitTestBox(bound:AABB):Boolean;
	}
}