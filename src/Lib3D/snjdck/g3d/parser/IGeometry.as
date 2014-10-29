package snjdck.g3d.parser
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.pickup.RayTestInfo;
	import snjdck.g3d.skeleton.BoneStateGroup;
	import snjdck.gpu.asset.GpuContext;

	public interface IGeometry
	{
		function get vertexCount():uint;
		function get numBones():int;
		function dispose():void;
		function getIndexData():Vector.<uint>;
		function testRay(ray:Ray, result:RayTestInfo, boneStateGroup:BoneStateGroup):Boolean;
		function getVertex(vertexIndex:uint, result:Vector3D, buffer:Vector.<Number>=null):void;
		function calculateBound(bound:AABB):void;
		
		function draw(context3d:GpuContext, worldMatrix:Matrix3D, boneStateGroup:BoneStateGroup):void;
		function get shaderName():String;
	}
}