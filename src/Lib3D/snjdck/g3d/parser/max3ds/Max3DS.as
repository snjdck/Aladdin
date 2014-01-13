package snjdck.g3d.parser.max3ds
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.parser.Geometry;
	
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
		
		public function Max3DS(ba:ByteArray)
		{
			ba.endian = Endian.LITTLE_ENDIAN;
			buffer = ba;
			mesh = new Mesh();
		}
		
		private function readChunk():void
		{
			const prevPosition:uint = buffer.position;
			const chunkId:uint = buffer.readUnsignedShort();
			const chunkSize:uint = buffer.readUnsignedInt();
			
			switch(chunkId)
			{
				case ChunkID.HEADER:
				case ChunkID.EDITOR:
				case ChunkID.KEYFRAME:
					readChunk();
					break;
				case ChunkID.VERSION:
					buffer.readInt();
					readChunk();
					break;
				case ChunkID.OBJECTS:
					trace("mesh", readString(buffer));
					readChunk();
					break;
				case ChunkID.MESH:
					if(subMesh){
						subMesh.geometry = new Geometry(vertexData, indexData);
					}
					subMesh = mesh.createSubMesh();
					subMesh.materialName = "shaokai";
					readChunk();
					break;
				case ChunkID.VERTICES:
					readVertices(buffer.readUnsignedShort());
					break;
				case ChunkID.INDICES:
					readIndices(buffer.readUnsignedShort());
					break;
				case ChunkID.UVS:
					readUvs(buffer.readUnsignedShort());
					break;
				default:
					trace("unknow chunk", chunkId, chunkSize);
					buffer.position = prevPosition + chunkSize;
					if(buffer.bytesAvailable > 0){
						readChunk();
					}
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