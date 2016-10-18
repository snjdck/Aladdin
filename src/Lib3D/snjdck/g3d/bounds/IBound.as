package snjdck.g3d.bounds
{
	public interface IBound
	{
		function hitTest(other:IBound):Boolean;
		function hitTestBox(other:AABB):Boolean;
		function hitTestSphere(other:Sphere):Boolean;
		
//		function classify():int;
	}
}