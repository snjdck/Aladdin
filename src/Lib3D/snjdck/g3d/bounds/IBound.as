package snjdck.g3d.bounds
{
	import snjdck.g3d.cameras.IViewFrustum;

	public interface IBound
	{
		function hitTest(other:IBound):Boolean;
		function hitTestSphere(other:Sphere):Boolean;
		function hitTestBox(other:AABB):Boolean;
		
		function classify(viewFrusum:IViewFrustum):int;
	}
}