package snjdck.g3d.mesh
{
	import snjdck.g3d.ns_g3d;
	import snjdck.gpu.asset.helper.ShaderName;
	import snjdck.g3d.geom.Ray;
	import snjdck.g3d.geom.RayTestInfo;
	import snjdck.g3d.parser.IGeometry;
	import snjdck.g3d.render.DrawUnit3D;
	
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
		
		final ns_g3d function getDrawUnit(drawUnit:DrawUnit3D, boneDict:Object):void
		{
			drawUnit.shaderName = boneDict ? ShaderName.BONE_ANI : ShaderName.OBJECT;
			drawUnit.textureName = materialName;
			geometry.getDrawUnit(drawUnit, boneDict);
		}
		
		final ns_g3d function testRay(ray:Ray, boneDict:Object, result:RayTestInfo):Boolean
		{
			return geometry.testRay(ray, result, boneDict);
		}
	}
}