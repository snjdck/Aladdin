package snjdck.fileformat.ogre
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import array.setValue;
	
	import lambda.call;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.asset.impl.GpuAssetFactory;
	import snjdck.g3d.mesh.BoneData;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.parser.DynamicGeometry;
	import snjdck.g3d.parser.Geometry;
	import snjdck.fileformat.ogre.support.MeshChunkID;
	import snjdck.fileformat.ogre.support.VertexBufferParam;
	import snjdck.fileformat.ogre.support.VertexElement;
	import snjdck.fileformat.ogre.support.VertexElementSemantic;
	import snjdck.fileformat.ogre.support.VertexElementType;
	
	import stream.readCString;
	
	use namespace ns_g3d;

	public class OgreMeshParser extends OgreParser
	{
		static public function Parse(ba:ByteArray):Mesh
		{
			ba.endian = Endian.LITTLE_ENDIAN;
			
			var parser:OgreMeshParser = new OgreMeshParser(ba);
			parser.parse();
			return parser.mesh;
		}
		
		private var skeletallyAnimated:Boolean;
		private var mesh:Mesh;
		private var sharedGeometry:Geometry;
		
		public function OgreMeshParser(ba:ByteArray)
		{
			super(ba);
		}
		
		private function parse():void
		{
			readHeader();
			seekToData();
			readMesh();
			while(buffer.bytesAvailable > 0){
				readUnknowChunk();
			}
		}
		
		private function readGeometry(indexData:Vector.<uint>):Geometry
		{
			var vertexElementList:Vector.<VertexElement> = new Vector.<VertexElement>();
			var vertexBufferList:Vector.<VertexBufferParam> = new Vector.<VertexBufferParam>();
			
			const geometryVertexCount:uint = buffer.readUnsignedInt();
			const vertexData:Vector.<Number> = new Vector.<Number>(geometryVertexCount*5);
//			var g:Geometry = skeletallyAnimated ? new DynamicGeometry(geometryVertexCount, indexData) : new Geometry(geometryVertexCount, indexData);
			
			seekToData();
			while(MeshChunkID.GEOMETRY_VERTEX_ELEMENT == getChunkId()){
				seekToData();
				vertexElementList.push(new VertexElement(buffer.readUnsignedShort(), buffer.readUnsignedShort(), buffer.readUnsignedShort(), buffer.readUnsignedShort()/4));
				buffer.position += 2;
			}
			
			while(MeshChunkID.GEOMETRY_VERTEX_BUFFER == getChunkId()){
				seekToData();
				var bindIndex:int = buffer.readUnsignedShort();
				var vb:VertexBufferParam = new VertexBufferParam(buffer.readUnsignedShort() / 4);
				buffer.position += 2;//M_GEOMETRY_VERTEX_BUFFER_DATA
				var vertexCount:int = (buffer.readUnsignedInt()-6) / 4;
				var vertexBuffer:Vector.<Number> = new Vector.<Number>(vertexCount, true);
//				GpuVertexBuffer.Bin2Vec(buffer, vertexBuffer, vertexCount);
				GpuAssetFactory.ReadVertexBufferFromByteArray(buffer, vertexCount, vertexBuffer);
				vb.data = vertexBuffer;
				vertexBufferList[bindIndex] = vb;
			}
			
			var vbp:VertexBufferParam, i:int, index:int;
			
			for each(var ve:VertexElement in vertexElementList){
				switch(ve.semantic){
					case VertexElementSemantic.POSITION:
						if(VertexElementType.FLOAT3 == ve.type){
							vbp = vertexBufferList[ve.source];
							for(i=0; i<geometryVertexCount; i++){
								index = vbp.data32PerVertex * i + ve.offset;
								array.setValue(vertexData, i*5, [vbp.data[index], vbp.data[index+1], vbp.data[index+2]]);
//								g.setPos(i, );
							}
						}else{
							throw new Error("vertex data must be float3!");
						}
					break;
					case VertexElementSemantic.TEXTURE_COORDINATES:
						if(VertexElementType.FLOAT2 == ve.type){
							vbp = vertexBufferList[ve.source];
							for(i=0; i<geometryVertexCount; i++){
								index = vbp.data32PerVertex * i + ve.offset;
//								g.setUV(i, vbp.data[index], vbp.data[index+1]);
								array.setValue(vertexData, i*5+3, [vbp.data[index], vbp.data[index+1]]);
							}
						}else{
							throw new Error("uv data must be float2!");
						}
					break;
				}
			}
			return lambda.call((skeletallyAnimated?DynamicGeometry:Geometry), vertexData, indexData);
		}
		
		private function readMesh():void
		{
			skeletallyAnimated = buffer.readBoolean();//important flag which affects h/w buffer policies
			mesh = new Mesh();
			
			if(MeshChunkID.GEOMETRY == getChunkId()){
				seekToData();
				sharedGeometry = readGeometry(null);
			}
			
			while(MeshChunkID.SUBMESH == getChunkId()){
				seekToData();
				addSubMesh();
			}
			
			if(MeshChunkID.MESH_SKELETON_LINK == getChunkId()){
				seekToData();
				mesh.skeletonLink = readCString(buffer);
			}
			
			if(MeshChunkID.MESH_BOUNDS == getChunkId()){
				seekToData();
				mesh.bound.readFromBuffer(buffer);
			}
		}
		
		private function addSubMesh():void
		{
			const subMesh:SubMesh = mesh.createSubMesh();
			
			subMesh.materialName = readCString(buffer);
			const useSharedVertices:Boolean = buffer.readBoolean();
			const indexCount:int = buffer.readUnsignedInt();
			
			if(buffer.readBoolean()){
				throw new Error("Index Data must be short type!");
			}
			
			const indexBuffer:Vector.<uint> = new Vector.<uint>(indexCount, true);
//			GpuIndexBuffer.Bin2Vec(buffer, indexBuffer, indexCount);
			GpuAssetFactory.ReadIndexBufferFromByteArray(buffer, indexCount, indexBuffer);
			
			if(useSharedVertices){
				//subMesh.geometry = geometry_create(sharedGeometry.getPosData(), sharedGeometry.getUvData(), indexBuffer);
			}else{
				seekToData();
				subMesh.geometry = readGeometry(indexBuffer);
			}
			
			if(MeshChunkID.SUBMESH_OPERATION == getChunkId()){
				seekToData();
				var operationType:uint = buffer.readUnsignedShort();
			}
			
			if(MeshChunkID.SUBMESH_BONE_ASSIGNMENT == getChunkId()){
				var boneData:BoneData = (subMesh.geometry as DynamicGeometry).boneData;
				while(MeshChunkID.SUBMESH_BONE_ASSIGNMENT == getChunkId()){
					seekToData();
					boneData.assignBone(buffer.readUnsignedInt(), buffer.readUnsignedShort(), buffer.readFloat());
				}
				boneData.adjustBoneWeight();
			}
			
			subMesh.onInit();
		}
	}
}