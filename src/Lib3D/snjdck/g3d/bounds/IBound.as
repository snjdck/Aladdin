package snjdck.g3d.bounds
{
	import snjdck.g3d.cameras.IViewFrustum;

	public interface IBound
	{
		function hitTest(other:IBound):Boolean;
		function hitTestBox(other:AABB):Boolean;
		
		function onHitTest(viewFrusum:IViewFrustum):Boolean;
		function onClassify(viewFrusum:IViewFrustum):int;
	}
}