package snjdck.g3d.skeleton
{
	import snjdck.g3d.geom.Matrix4x4;

	public interface IBoneStateGroup
	{
		function getBoneState(boneId:int):Matrix4x4;
	}
}