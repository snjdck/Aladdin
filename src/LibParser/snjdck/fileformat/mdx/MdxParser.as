package snjdck.fileformat.mdx
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.geom.Quaternion;
	import snjdck.g3d.mesh.BoneData;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.parser.Geometry;
	import snjdck.g3d.skeleton.Animation;
	import snjdck.g3d.skeleton.Bone;
	import snjdck.g3d.skeleton.Skeleton;
	import snjdck.model3d.mergeVertexUV;
	import snjdck.model3d.importer.readIndices;
	import snjdck.model3d.importer.readUVs;
	import snjdck.model3d.importer.readVertices;
	import snjdck.model3d.importer.readuBytes;
	
	import stream.readFixedString;
	import stream.readVector3;
	
	use namespace ns_g3d;

	/**
	 * 至于UI资源的提取，先用MPQMaster把WAR3.MPQ中的所有东西都解压出来，然后再用BLPLaboratory把blp文件转换成png文件。
	 */	
	public class MdxParser
	{
		private var handlerDict:Object = {};
		
		public var mesh:Mesh;
		public var skeleton:Skeleton;
		private var subMesh:SubMesh;
		
		private const materialList:Array = [];
		private const texList:Array = [];
		
		public function MdxParser()
		{
			handlerDict["VERS"] = onReadVers;
			handlerDict["MODL"] = onReadModl;
			handlerDict["SEQS"] = onReadSeqs;
			handlerDict["MTLS"] = onReadMtls;
			handlerDict["TEXS"] = onReadTexs;
			handlerDict["GEOS"] = onReadGeos;
			handlerDict["GLBS"] = onReadGlobalSequence;
			handlerDict["HELP"] = onReadHelpers;
			handlerDict["ATCH"] = onReadAttachment;
			handlerDict["BONE"] = onReadBoneChunk;
		}
		
		private function onReadBoneChunk(ba:ByteArray, endPos:uint):void
		{
			while(ba.position < endPos){
				readBone(ba);
			}
			skeleton.onInit();
		}
		
		private function readBone(ba:ByteArray):void
		{
			readNode(ba);
			var geosetId:int = ba.readInt();
			var geosetAnimationId:int = ba.readInt();
			trace("bone", geosetId, geosetAnimationId);
		}
		
		private function onReadAttachment(ba:ByteArray, endPos:uint):void
		{
			while(ba.position < endPos){
				readAttachment(ba);
			}
		}
		
		private function readAttachment(ba:ByteArray):void
		{
			var endPos:int = ba.position;
			var inclusiveSize:int = ba.readInt();
			endPos += inclusiveSize;
			
			readNode(ba);
			readFixedString(ba, 260);
			var attachmentId:int = ba.readInt();
			if(ba.position < endPos){
				readAttachmentVisibility(ba);
			}
		}
		
		private function readAttachmentVisibility(ba:ByteArray):void
		{
			ba.readUTFBytes(4);
			
			var trackCount:uint = ba.readUnsignedInt();
			var interpolationType:uint = ba.readUnsignedInt();
			var globalSequenceId:uint = ba.readUnsignedInt();
			for(var i:int=0; i<trackCount; ++i){
				var time:uint = ba.readUnsignedInt();
				ba.readFloat();
				if(interpolationType > 1){
					ba.readFloat();//inTan
					ba.readFloat();//outTan
				}
			}
		}
		
		private function onReadHelpers(ba:ByteArray, endPos:uint):void
		{
			while(ba.position < endPos){
				readNode(ba);
			}
		}
		
		private function onReadGlobalSequence(ba:ByteArray, endPos:uint):void
		{
			while(ba.position < endPos){
				var duration:uint = ba.readUnsignedInt();
				trace("global seq duration", duration);
			}
		}
		
		private function onReadVers(ba:ByteArray, endPos:uint):void
		{
			var version:uint = ba.readUnsignedInt();
		}
		
		private function onReadModl(ba:ByteArray, endPos:uint):void
		{
			trace(readFixedString(ba, 80));
			trace(readFixedString(ba, 260));
			readBound(ba);
			var blendTime:uint = ba.readUnsignedInt();
		}
		
		private function onReadSeqs(ba:ByteArray, endPos:uint):void
		{
			while(ba.position < endPos){
				readSequenceName(ba);
			}
		}
		
		private function onReadMtls(ba:ByteArray, endPos:uint):void
		{
			while(ba.position < endPos){
				materialList.push(readMaterial(ba));
			}
		}
		
		private function readMaterial(ba:ByteArray):Array
		{
			var inclusiveSize:uint = ba.readUnsignedInt();
			var priorityPlane:uint = ba.readUnsignedInt();
			var flags:uint = ba.readUnsignedInt();
			assert(ba.readUTFBytes(4) == "LAYS");
			var count:uint = ba.readUnsignedInt();
			trace("material layer count", count);
			var result:Array = [];
			while(count-- > 0){
				result.push(readLayer(ba));
			}
			return result;
		}
		
		private function readLayer(ba:ByteArray):uint
		{
			var inclusiveSize:int = ba.readUnsignedInt();
			var endPos:int = ba.position + inclusiveSize - 4;
			var filterMode:uint = ba.readUnsignedInt();
			var shadingFlags:uint = ba.readUnsignedInt();
			var textureId:uint = ba.readUnsignedInt();
			var textureAnimationId:uint = ba.readUnsignedInt();
			var coordId:int = ba.readUnsignedInt();
			var alpha:Number = ba.readFloat();
			while(ba.position < endPos){
				readAttachmentVisibility(ba);
			}
			return textureId;
		}
		
		private function onReadTexs(ba:ByteArray, endPos:uint):void
		{
			while(ba.position < endPos){
				ba.position += 4;
				var texName:String = readFixedString(ba, 260);
				if(null == texName){
					texName = texList[texList.length-1];
				}
				texList.push(texName);
				ba.position += 4;
			}
			trace(texList);
		}
		
		private function onReadGeos(ba:ByteArray, endPos:uint):void
		{
			while(ba.position < endPos){
				readGeoChunk(ba);
			}
		}
		
		public function parse(ba:ByteArray):void
		{
			ba.endian = Endian.LITTLE_ENDIAN;
			assert(ba.readUTFBytes(4) == "MDLX");
			mesh = new Mesh();
			skeleton = new Skeleton();
			while(ba.bytesAvailable > 0){
				readTag(ba);
			}
		}
		
		private function readTag(ba:ByteArray):void
		{
			var tag:String = ba.readUTFBytes(4);
			var size:uint = ba.readUnsignedInt();
			var endPos:uint = ba.position + size;
			var handler:Function = handlerDict[tag];
			if(null == handler){
				trace(tag, size, ba.position.toString(16));
				ba.position += size;
			}else{
				handler(ba, endPos);
			}
			assert(ba.position == endPos);
		}
		
		private function readSequenceName(ba:ByteArray):void
		{
			var name:String = readFixedString(ba, 80);
			var IntervalStart:int = ba.readInt();
			var IntervalEnd:int = ba.readInt();
			var MoveSpeed:Number = ba.readFloat();
			var flags:uint = ba.readUnsignedInt();//0 - Looping//1 - NonLooping
			var Rarity:Number = ba.readFloat();
			var SyncPoint:int = ba.readInt();
			readBound(ba);
		}
		
		private function readGeoChunk(ba:ByteArray):void
		{
			var index:int = mesh.subMeshCount;
			subMesh = mesh.createSubMesh();
			ba.readUnsignedInt();
			var vertexList:Vector.<Number> = readVertex(ba);
			readNormal(ba);
			readPrimitivesType(ba);
			readPrimitivesCount(ba);
			var vertexIndex:Vector.<uint> = readPrimitivesVertices(ba);
//			trace("----------------", vertexList.length / 3);
			var bind:Array = readVertexGroupIndices(ba);
			readGroupMatrixCounts(ba);
			readMatrices(ba);
			var materialId:uint = ba.readUnsignedInt();
			trace("geom", index, materialId);
			var selectionGroup:uint = ba.readUnsignedInt();
			var selectionFlags:uint = ba.readUnsignedInt();
			readBound(ba);
			var count:uint = ba.readUnsignedInt();
			for(var i:int=0; i<count; ++i){
				readBound(ba);
			}
			readUvas(ba);
			var uvList:Vector.<Number> = readUvbs(ba);
			var geom:Geometry = new Geometry(mergeVertexUV(vertexList, uvList), vertexIndex);
			subMesh.geometry = geom;
			subMesh.materialName = texList[materialList[materialId][0]];
			
			var vertexCount:int = uvList.length >> 1;
			var boneData:BoneData = new BoneData(vertexCount);
			for(var i:int=0; i<vertexCount; ++i){
				boneData.assignBone(i, bind[i], 1);
			}
		}
		
		private function readBound(ba:ByteArray):void
		{
			var boundsRadius:Number = ba.readFloat();
			readVector3(ba, new Vector3D());//vec min
			readVector3(ba, new Vector3D());//vec max
		}
		
		private function readVertex(ba:ByteArray):Vector.<Number>
		{
			assert(ba.readUTFBytes(4) == "VRTX");
			return readVertices(ba, ba.readInt());
		}
		
		private function readNormal(ba:ByteArray):void
		{
			assert(ba.readUTFBytes(4) == "NRMS");
			var count:uint = ba.readUnsignedInt();
			ba.position += count * 12;//vec3
		}
		
		private function readPrimitivesType(ba:ByteArray):void
		{
			assert(ba.readUTFBytes(4) == "PTYP");
			var count:uint = ba.readUnsignedInt();
			ba.position += count * 4;
		}
		
		private function readPrimitivesCount(ba:ByteArray):void
		{
			assert(ba.readUTFBytes(4) == "PCNT");
			var count:uint = ba.readUnsignedInt();
			ba.position += count * 4;
		}
		
		private function readPrimitivesVertices(ba:ByteArray):Vector.<uint>
		{
			assert(ba.readUTFBytes(4) == "PVTX");
			return readIndices(ba, ba.readInt());
		}
		
		private function readVertexGroupIndices(ba:ByteArray):Array
		{
			assert(ba.readUTFBytes(4) == "GNDX");
			var count:uint = ba.readUnsignedInt();
			return readuBytes(ba, count);
		}
		
		private function readGroupMatrixCounts(ba:ByteArray):void
		{
			assert(ba.readUTFBytes(4) == "MTGC");
			var count:uint = ba.readUnsignedInt();
			ba.position += count * 4;
		}
		
		private function readMatrices(ba:ByteArray):void
		{
			assert(ba.readUTFBytes(4) == "MATS");
			var count:uint = ba.readUnsignedInt();
			ba.position += count * 4;
		}
		
		private function readUvas(ba:ByteArray):void
		{
			assert(ba.readUTFBytes(4) == "UVAS");
			var count:uint = ba.readUnsignedInt();
		}
		
		private function readUvbs(ba:ByteArray):Vector.<Number>
		{
			assert(ba.readUTFBytes(4) == "UVBS");
			return readUVs(ba, ba.readInt());
		}
		
		private function readNode(ba:ByteArray):void
		{
			var endPos:int = ba.position;
			var inclusiveSize:int = ba.readInt();
			endPos += inclusiveSize;
			var nodeName:String = readFixedString(ba, 80);
			var objId:int = ba.readInt();
			var parentId:int = ba.readInt();
			var flags:uint = ba.readUnsignedInt();
			trace("node",nodeName,objId,parentId);
			
			if(flags & 0x100){
				var bone:Bone = new Bone(nodeName, objId);
				bone.parentId = parentId;
				skeleton.addBone(bone);
			}
			
			var ani:Animation = new Animation("0", 5);
			
			while(ba.position < endPos){
				var key:String = ba.readUTFBytes(4);
				switch(key){
					case "KGTR":
						readGeosetTranslation(ba);
						break;
					case "KGRT":
						readGeosetRotation(ba);
						break;
					case "KGSC":
						readGeosetTranslation(ba);
						break;
				}
			}
		}
		
		private function readGeosetTranslation(ba:ByteArray):void
		{
			var trackCount:uint = ba.readUnsignedInt();
			var interpolationType:uint = ba.readUnsignedInt();
			var globalSequenceId:int = ba.readInt();
			trace("global seq id", globalSequenceId);
			for(var i:int=0; i<trackCount; ++i){
				var time:uint = ba.readUnsignedInt();
				readVector3(ba, new Vector3D());//translation
				if(interpolationType > 1){
					readVector3(ba, new Vector3D());//inTan
					readVector3(ba, new Vector3D());//outTan
				}
			}
		}
		
		private function readGeosetRotation(ba:ByteArray):void
		{
			var trackCount:uint = ba.readUnsignedInt();
			var interpolationType:uint = ba.readUnsignedInt();
			var globalSequenceId:uint = ba.readUnsignedInt();
			for(var i:int=0; i<trackCount; ++i){
				var time:uint = ba.readUnsignedInt();
				new Quaternion().readFrom(ba);
				if(interpolationType > 1){
					new Quaternion().readFrom(ba);
					new Quaternion().readFrom(ba);
				}
			}
		}
	}
}