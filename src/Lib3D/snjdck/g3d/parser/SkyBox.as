package snjdck.g3d.parser
{
	import flash.utils.ByteArray;
	
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	
	internal class SkyBox extends Mesh
	{
		private var size:int;
		private var materialName:String;
		
		public function SkyBox(size:int, materialName:String)
		{
			this.size = size;
			this.materialName = materialName;
			createSkyBox();
		}
		
		private function createSkyBox():void
		{
			/*
			var subMesh:SubMesh = createSubMesh();
			
			var geometry:Geometry = new Geometry();
			var vb:VertexBufferParam = new VertexBufferParam(3);
			generateVerticeBuffer(vb.data);
			geometry.addVertexBuffer(0, vb);
			geometry.addVertexElement(new VertexElement(0, VertexElementType.FLOAT3, VertexElementSemantic.POSITION, 0));
			
			subMesh.materialName = materialName;
			subMesh.geometry = geometry;
			generateIndexBuffer(subMesh.indexBuffer);
			*/
		}
		
		private function generateVerticeBuffer(output:ByteArray):void
		{
			var halfSize:Number = size * 0.5;
			
			output.writeFloat(-1*halfSize);	output.writeFloat(1*halfSize);	output.writeFloat(-1*halfSize);	//top left near
			output.writeFloat(1*halfSize);	output.writeFloat(1*halfSize);	output.writeFloat(-1*halfSize);	//top right near
			output.writeFloat(1*halfSize);	output.writeFloat(1*halfSize);	output.writeFloat(1*halfSize);	//top right far
			output.writeFloat(-1*halfSize);	output.writeFloat(1*halfSize);	output.writeFloat(1*halfSize);	//top left far
			output.writeFloat(-1*halfSize);	output.writeFloat(-1*halfSize);	output.writeFloat(-1*halfSize);	//bottom left near
			output.writeFloat(1*halfSize);	output.writeFloat(-1*halfSize);	output.writeFloat(-1*halfSize);	//bottom right near
			output.writeFloat(1*halfSize);	output.writeFloat(-1*halfSize);	output.writeFloat(1*halfSize);	//bottom right far
			output.writeFloat(-1*halfSize);	output.writeFloat(-1*halfSize);	output.writeFloat(1*halfSize);	//bottom left far
		}
		
		private function generateIndexBuffer(output:Vector.<uint>):void
		{
			output.push(
				0, 1, 2, 0, 2, 3,		//top
				7, 6, 5, 7, 5, 4,		//bottom
				3, 2, 6, 3, 6, 7,		//far
				1, 0, 4, 1, 4, 5,		//near
				0, 3, 7, 0, 7, 4,		//left
				2, 1, 5, 2, 5, 6		//right
			);
		}
	}
}