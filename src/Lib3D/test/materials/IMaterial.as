package test.materials
{
	import flash.display3D.Context3D;
	
	import test.ProgramInfoStack;
	import test.SubMesh;

	public interface IMaterial
	{
		function draw(context3d:Context3D, subMesh:SubMesh, contextStack:ProgramInfoStack):void;
	}
}