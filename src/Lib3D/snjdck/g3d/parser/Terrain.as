package snjdck.g3d.parser
{
	import geom3d.createMeshIndices;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	
	use namespace ns_g3d;
	
	public class Terrain extends Mesh
	{
		static private const MAX_VERTEX_COUNT:uint = 0xFFFF;
		
		private var cellSize:Number;
		private var textureSize:uint;
		private var z:Number;
		
		private var materialName:String;
		
		/**
		 * @param numVertexPerRow 一行有几个顶点
		 * @param numVertexPerCol 一列有几个顶点
		 * @param cellSize
		 * @param textureSize
		 */
		public function Terrain(numVertexPerRow:uint, numVertexPerCol:uint, cellSize:Number, textureSize:uint, materialName:String, z:Number=0)
		{
			this.cellSize = cellSize;
			this.textureSize = textureSize;
			
			this.materialName = materialName;
			this.z = z;
			
			var halfWidth:Number = cellSize * (numVertexPerRow - 1) * 0.5;
			var halfHeight:Number = cellSize * (numVertexPerCol - 1) * 0.5;
			
			createTerrain(numVertexPerRow, numVertexPerCol, -halfWidth, -halfHeight);
		}
		
		private function createTerrain(numVertexPerRow:uint, numVertexPerCol:uint, offsetX:Number, offsetY:Number):void
		{
			var numCells:int;
			
			if(numVertexPerRow * numVertexPerCol > MAX_VERTEX_COUNT){
				if(numVertexPerRow > numVertexPerCol){
					numCells = MAX_VERTEX_COUNT / numVertexPerCol - 1;
					createSubTerrain(numCells + 1, numVertexPerCol, offsetX, offsetY);
					arguments.callee(numVertexPerRow-numCells, numVertexPerCol, offsetX+cellSize*numCells, offsetY);
				}else{
					numCells = MAX_VERTEX_COUNT / numVertexPerRow - 1;
					createSubTerrain(numVertexPerRow, numCells + 1, offsetX, offsetY);
					arguments.callee(numVertexPerRow, numVertexPerCol-numCells, offsetX, offsetY+cellSize*numCells);
				}
			}else{
				createSubTerrain(numVertexPerRow, numVertexPerCol, offsetX, offsetY);
			}
		}
		
		private function createSubTerrain(numVertexPerRow:uint, numVertexPerCol:uint, offsetX:Number, offsetY:Number):void
		{
			var subTerrain:SubMesh = createSubMesh();
			
//			var geometry:Geometry = new Geometry(numVertexPerRow*numVertexPerCol, generateIndexBuffer(numVertexPerRow, numVertexPerCol));
			var geometry:Geometry = new Geometry(
				generateVerticeBuffer(numVertexPerRow, numVertexPerCol, offsetX, offsetY),
				generateIndexBuffer(numVertexPerRow, numVertexPerCol)
			);
//			generateVerticeBuffer(geometry, numVertexPerRow, numVertexPerCol, offsetX, offsetY);
			
			subTerrain.geometry = geometry;
			subTerrain.materialName = materialName;
		}
		
		private function generateVerticeBuffer(numVertexPerRow:uint, numVertexPerCol:uint, offsetX:Number, offsetY:Number):Vector.<Number>
		{
			var vertexData:Vector.<Number> = new Vector.<Number>();
			for(var row:int=0; row<numVertexPerCol; row++){
				for(var col:int=0; col<numVertexPerRow; col++){
					var px:Number = col * cellSize;
					var py:Number = row * cellSize;
//					geometry.setVertex(row*numVertexPerRow+col, px+offsetX, py+offsetY, z, px/textureSize, py/textureSize);
					vertexData.push(px+offsetX, py+offsetY, z, px/textureSize, py/textureSize);
				}
			}
			return vertexData;
		}
		
		private function generateIndexBuffer(numVertexPerRow:uint, numVertexPerCol:uint):Vector.<uint>
		{
			var indexBuffer:Vector.<uint> = new Vector.<uint>();
			createMeshIndices(numVertexPerRow, numVertexPerCol, indexBuffer);
			return indexBuffer;
		}
	}
}