package snjdck.fileformat.max3ds
{
	import flash.geom.Matrix3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import array.copy;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.parser.Geometry;
	
	import stream.readMatrix34;
	import stream.readString;
	
	use namespace ns_g3d;

	public class Max3DS
	{
		static public function Parse(ba:ByteArray):Mesh
		{
			ba.endian = Endian.LITTLE_ENDIAN;
			
			var parser:Max3DS = new Max3DS(ba);
			parser.readChunk();
			return parser.mesh;
		}
		
		private var buffer:ByteArray;
		
		private var mesh:Mesh;
		private var subMesh:SubMesh;
		private var vertexData:Vector.<Number>;
		private var indexData:Vector.<uint>;
		
		private const materialDict:Object = {};
		private var materialName:String;
		
		public function Max3DS(ba:ByteArray)
		{
			ba.endian = Endian.LITTLE_ENDIAN;
			buffer = ba;
			mesh = new Mesh();
		}
		
		private function readChunk():void
		{
			while(buffer.bytesAvailable > 0){
				readChunkImpl();
			}
		}
		
		private function readChunkImpl():void
		{
			const chunkId:uint = buffer.readUnsignedShort();
			const chunkSize:uint = buffer.readUnsignedInt() - 6;
			const prevPosition:uint = buffer.position;
			
			switch(chunkId)
			{
				case ChunkID.HEADER:
				case ChunkID.EDITOR:
				case ChunkID.KEYFRAME:
				case ChunkID.MAT_AMBIENT:
				case ChunkID.MAT_DIFFUSE:
				case ChunkID.MAT_SPECULAR:
				case ChunkID.MAT_SHININESS:
				case ChunkID.MAT_TEXMAP:
					break;
				case ChunkID.VERSION:
					buffer.readInt();
					break;
				case ChunkID.OBJECTS:
					readString(buffer);
					break;
				case ChunkID.MESH:
					subMesh = mesh.createSubMesh();
					break;
				case ChunkID.VERTICES:
					readVertices(buffer.readUnsignedShort());
					break;
				case ChunkID.INDICES:
					readIndices(buffer.readUnsignedShort());
					var vertexCount:int = vertexData.length / 5;
					subMesh.geometry = new Geometry(vertexCount);
					subMesh.geometry.indexData = indexData;
					for(var i:int=0; i<vertexCount; ++i){
						array.copy(vertexData, subMesh.geometry.posData, 3, i*5, i*3);
						array.copy(vertexData, subMesh.geometry.uvData, 2, i*5+3, i*2);
					}
					break;
				case ChunkID.MESH_MATER:
					subMesh.materialName = materialDict[readString(buffer)];
					var n:int = buffer.readUnsignedShort();
					buffer.position += n * 2;
					break;
				case ChunkID.UVS:
					readUvs(buffer.readUnsignedShort());
					break;
				case ChunkID.MATERIAL_LIST:
					break;
				case ChunkID.MATERIAL_NAME:
					materialName = readString(buffer);
					break;
				case ChunkID.MAT_TEXFLNM:
					var textureName:String = readString(buffer).toLowerCase();
					var index:int = textureName.indexOf(".");
					if(index < 0){
						index = textureName.length;
					}
					materialDict[materialName] = textureName.slice(0, index);
					break;
				case ChunkID.TRI_LOCAL:
					var t:Matrix3D = new Matrix3D();
					readMatrix34(buffer, t);
					break;
				case ChunkID.KEYF_FRAME_COUNT:
					var fromIndex:uint = buffer.readUnsignedInt();
					var toIndex:uint = buffer.readUnsignedInt();
					break;
				case 0xb010:
					readString(buffer);
					buffer.readUnsignedShort();
					buffer.readUnsignedShort();
					buffer.readUnsignedShort();
					break;
				case ChunkID.KEYF_OBJDES:
					break;
				default:
//					trace("unknow chunk",chunkId, "\t\t0x"+chunkId.toString(16), "\t", chunkSize);
					buffer.position = prevPosition + chunkSize;
			}
		}
			
		private function readVertices(n:int):void
		{
			vertexData = new Vector.<Number>(n*5, true);
			for(var i:int=0; i<n; i++){
				var index:int = i * 5;
				vertexData[index] = buffer.readFloat();
				vertexData[index+1] = buffer.readFloat();
				vertexData[index+2] = buffer.readFloat();
			}
		}
		
		private function readIndices(n:int):void
		{
			indexData = new Vector.<uint>(n*3, true);
			for(var i:int=0; i<n; i++){
				var index:int = i * 3;
				indexData[index] = buffer.readUnsignedShort();
				indexData[index+1] = buffer.readUnsignedShort();
				indexData[index+2] = buffer.readUnsignedShort();
				buffer.readUnsignedShort();
			}
		}
		
		private function readUvs(n:int):void
		{
			for(var i:int=0; i<n; i++){
				var index:int = i * 5;
				vertexData[index+3] = buffer.readFloat();
				vertexData[index+4] = buffer.readFloat();
			}
		}
	}
}