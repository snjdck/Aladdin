package snjdck.fileformat.mdx
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.parser.Geometry;
	
	import stream.readFixedString;
	import snjdck.model3d.importer.readUVs;
	import stream.readVector3;
	import snjdck.model3d.importer.readIndices;
	import snjdck.model3d.importer.readVertices;
	import snjdck.model3d.mergeVertexUV;

	/**
	 * 至于UI资源的提取，先用MPQMaster把WAR3.MPQ中的所有东西都解压出来，然后再用BLPLaboratory把blp文件转换成png文件。
	 */	
	public class MdxParser
	{
		private var handlerDict:Object = {};
		
		public var mesh:Mesh;
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
		}
		
		private function onReadVers(ba:ByteArray, endPos:uint):void
		{
			trace("vsersion", ba.readUnsignedInt());
		}
		
		private function onReadModl(ba:ByteArray, endPos:uint):void
		{
			trace(readFixedString(ba, 80));
			trace(readFixedString(ba, 260));
			readBound(ba);
			ba.position += 4;
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
			ba.position = endPos;
		}
		
		private function readMaterial(ba:ByteArray):Array
		{
			ba.readUnsignedInt();
			ba.position += 8;
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
			var n:int = ba.readUnsignedInt();
			var end:int = ba.position + n - 4;
			if(n != 28){
//				enterDebugger();
			}
			var blendMode:uint = ba.readUnsignedInt();
			var shadingFlags:uint = ba.readUnsignedInt();
			var texture:uint = ba.readUnsignedInt();
			ba.readUnsignedInt();
			ba.readUnsignedInt();
			ba.readFloat();
			ba.position = end;
			return texture;
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
			ba.position += 28;
			readVector3(ba, new Vector3D());//vec min
			readVector3(ba, new Vector3D());//vec max
		}
		
		private function readGeoChunk(ba:ByteArray):void
		{
			subMesh = mesh.createSubMesh();
			trace("geom", ba.readUnsignedInt());
			var vertexList:Vector.<Number> = readVertex(ba);
			readNormal(ba);
			readPrimitivesType(ba);
			readPrimitivesCount(ba);
			var vertexIndex:Vector.<uint> = readPrimitivesVertices(ba);
			readVertexGroupIndices(ba);
			readGroupMatrixCounts(ba);
			readMatrices(ba);
			var materialId:uint = ba.readUnsignedInt();
			trace("material", materialId);
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
			trace(subMesh.materialName);
		}
		
		private function readBound(ba:ByteArray):void
		{
			var boundsRadius:Number = ba.readFloat();
			//bounding box
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
		
		private function readVertexGroupIndices(ba:ByteArray):void
		{
			assert(ba.readUTFBytes(4) == "GNDX");
			var count:uint = ba.readUnsignedInt();
			ba.position += count;
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
	}
}