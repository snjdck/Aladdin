package snjdck.g3d.parser
{
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.skeleton.IBoneStateGroup;
	import snjdck.gpu.asset.GpuContext;

	public interface IGeometry
	{
		function get vertexCount():uint;
		function get numBones():int;
		function dispose():void;
		function calculateBound():void;
		function get bound():AABB;
		
		function draw(context3d:GpuContext, boneStateGroup:IBoneStateGroup):void;
	}
}