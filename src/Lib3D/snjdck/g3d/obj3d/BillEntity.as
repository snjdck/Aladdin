package snjdck.g3d.obj3d
{
	import flash.geom.Vector3D;
	
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.ns_g3d;
	
	use namespace ns_g3d;
	
	public class BillEntity extends Entity
	{
		public function BillEntity(mesh:Mesh, boneDict:Object)
		{
			super(mesh, boneDict);
		}
		/*
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D, camera:Camera3D):void
		{
				var componentVec:Vector.<Vector3D> = worldMatrix.decompose();
				worldMatrix.copyFrom(localMatrix);
				worldMatrix.append(camera.worldMatrix);
				componentVec[1] = worldMatrix.decompose()[1];
				worldMatrix.recompose(componentVec);
			super.ns_g3d::collectDrawUnit(collector, camera);
		}
		*/
	}
}