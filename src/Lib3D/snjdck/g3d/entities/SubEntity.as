package snjdck.g3d.entities
{
	import snjdck.g3d.mesh.SubMesh;

	public class SubEntity
	{
		public var visible:Boolean;
		public var subMesh:SubMesh;
		
		public function SubEntity(subMesh:SubMesh)
		{
			this.subMesh = subMesh;
			visible = true;
		}
	}
}