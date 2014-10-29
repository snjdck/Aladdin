package snjdck.g3d.obj3d
{
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.parser.Geometry;
	
	use namespace ns_g3d;
	
	public class BillBoard extends Mesh
	{
		public var size:Number;
		private var materialName:String;
		
		public function BillBoard(size:Number, materialName:String)
		{
			this.size = size;
			this.materialName = materialName;
			createBill();
//			bound.minX = bound.minY = size * -0.5;
//			bound.maxX = bound.maxY = size * 0.5;
//			bound.minZ = 0; bound.maxZ = 1;
//			bound.radius = size * 0.5;
		}
		
		private function createBill():void
		{
//			var g:Geometry = new Geometry(4, new <uint>[0, 1, 2, 0, 2, 3]);
			
			var halfSize:Number = size * 0.5;
//			g.setVertex(0, -halfSize, halfSize, 0, 0, 0);
//			g.setVertex(1, halfSize, halfSize, 0, 1, 0);
//			g.setVertex(2, halfSize, -halfSize, 0, 1, 1);
//			g.setVertex(3, -halfSize, -halfSize, 0, 0, 1);
			var g:Geometry = new Geometry(new <Number>[
				-halfSize, halfSize, 0, 0, 0,
				halfSize, halfSize, 0, 1, 0,
				halfSize, -halfSize, 0, 1, 1,
				-halfSize, -halfSize, 0, 0, 1
			], new <uint>[0, 1, 2, 0, 2, 3]);
			
			var subMesh:SubMesh = createSubMesh();
			
			subMesh.materialName = materialName;
			subMesh.geometry = g;
		}
		
		override public function createEntity(name:String=null):Entity
		{
			return createEntityImp(name, BillEntity);
		}
	}
}