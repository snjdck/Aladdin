package snjdck.g3d.cameras
{
	import snjdck.g3d.bounds.AABB;
	import snjdck.g3d.bounds.IBound;
	import snjdck.g3d.bounds.Sphere;

	public interface IViewFrustum
	{
		function classify(bound:IBound):int;
		function classifySphere(bound:Sphere):int;
		function classifyBox(bound:AABB):int;
		
		function hitTest(bound:IBound):Boolean;
		function hitTestSphere(bound:Sphere):Boolean;
		function hitTestBox(bound:AABB):Boolean;
	}
}