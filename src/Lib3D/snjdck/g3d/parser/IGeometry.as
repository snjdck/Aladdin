package snjdck.g3d.parser
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.skeleton.BoneStateGroup;
	import snjdck.gpu.asset.GpuContext;

	public interface IGeometry
	{
		function get vertexCount():uint;
		function get numBones():int;
		function dispose():void;
		function getIndexData():Vector.<uint>;
		function testRay(ray:Ray, mouseLocation:Vector3D, boneStateGroup:BoneStateGroup):Boolean;
		function getVertex(vertexIndex:uint, result:Vector3D, buffer:Vector.<Number>=null):void;
		function calculateBound():void;
		function get bound():AABB;
		
		function draw(context3d:GpuContext, boneStateGroup:BoneStateGroup):void;
	}
}