package snjdck.g3d.geom
{
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.ns_g3d;
	
	use namespace ns_g3d;
	
	public class Wireframe extends Object3D
	{
		public function Wireframe(mesh:Mesh, thickness:Number=1)
		{
			mouseEnabled = mouseChildren = false;
			for each(var subMesh:SubMesh in mesh.subMeshes){
				addChild(new SubWireframe(subMesh, thickness));
			}
		}
	}
}