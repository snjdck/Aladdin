package snjdck.g3d.parser
{
	import flash.geom.Vector3D;
	
	import snjdck.g3d.geom.Bound;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.pickup.RayTestInfo;
	import snjdck.g3d.render.DrawUnit3D;
	import snjdck.g3d.skeleton.BoneStateGroup;

	public interface IGeometry
	{
		function get vertexCount():uint;
		function get numBones():int;
		function dispose():void;
		function getIndexData():Vector.<uint>;
		function getDrawUnit(drawUnit:DrawUnit3D, boneStateGroup:BoneStateGroup):void;
		function testRay(ray:Ray, result:RayTestInfo, boneStateGroup:BoneStateGroup):Boolean;
		function getVertex(vertexIndex:uint, result:Vector3D, buffer:Vector.<Number>=null):void;
		function calculateBound(bound:Bound):void;
	}
}