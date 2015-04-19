package snjdck.g3d.mesh
{
	import flash.geom.Vector3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.parser.IGeometry;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.skeleton.BoneStateGroup;
	
	use namespace ns_g3d;
	
	final public class SubMesh 
	{
		public var materialName:String;
		public var geometry:IGeometry;
		
		public function SubMesh()
		{
		}
		
		public function onInit():void
		{
			trace(this, "骨骼数量:", geometry.numBones, "材质名称:", materialName);
		}
		
		final ns_g3d function testRay(ray:Ray, boneStateGroup:BoneStateGroup, mouseLocation:Vector3D):Boolean
		{
			return geometry.testRay(ray, mouseLocation, boneStateGroup);
		}
	}
}