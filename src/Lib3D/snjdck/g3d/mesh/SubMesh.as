package snjdck.g3d.mesh
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.parser.IGeometry;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.pickup.RayTestInfo;
	import snjdck.g3d.render.DrawUnit3D;
	import snjdck.g3d.skeleton.BoneStateGroup;
	
	use namespace ns_g3d;
	
	final public class SubMesh
	{
		public var materialName:String;
		public var geometry:IGeometry;
		
		public const drawUnit:DrawUnit3D = new DrawUnit3D();
		
		public function SubMesh()
		{
		}
		
		public function onInit():void
		{
			trace(this, "骨骼数量:", geometry.numBones, "材质名称:", materialName);
		}
		
		final ns_g3d function testRay(ray:Ray, boneStateGroup:BoneStateGroup, result:RayTestInfo):Boolean
		{
			return geometry.testRay(ray, result, boneStateGroup);
		}
	}
}