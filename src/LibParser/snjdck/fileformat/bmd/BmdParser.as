package snjdck.fileformat.bmd
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import array.setValue;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.geom.Matrix4x4;
	import snjdck.g3d.mesh.BoneData;
	import snjdck.g3d.mesh.Mesh;
	import snjdck.g3d.mesh.SubMesh;
	import snjdck.g3d.parser.Geometry;
	import snjdck.g3d.skeleton.Animation;
	import snjdck.g3d.skeleton.Bone;
	import snjdck.g3d.skeleton.KeyFrame;
	import snjdck.g3d.skeleton.Skeleton;
	
	import stream.readFixedString;
	
	use namespace ns_g3d;

	public class BmdParser
	{
		static public function Parse(ba:ByteArray):Mesh
		{
			ba.endian = Endian.LITTLE_ENDIAN;
			
			var parser:BmdParser = new BmdParser(ba);
			parser.parse();
			return parser.mesh;
		}
		
		private var buffer:ByteArray;
		
		public var mesh:Mesh;
		private var skeleton:Skeleton;
		
		private var isStaticMesh:Boolean;
		private var lastKeyFrameTransform:Matrix4x4;
		
		
		public function BmdParser(ba:ByteArray)
		{
			buffer = ba;
			
			mesh = new Mesh();
			skeleton = new Skeleton();
			
			mesh.skeleton = skeleton;
		}
		
		static private const keyList:Array = [0xd1, 0x73, 0x52, 0xf6, 0xd2, 0x9a, 0xcb, 0x27, 0x3e, 0xaf, 0x59, 0x31, 0x37, 0xb3, 0xe7, 0xa2];
		private function decodeBmd():void
		{
			var keyIndex:int = 0;
			var offset:int = 0x5E;
			
			for(var i:int=buffer.position, n:int=buffer.length; i<n; ++i)
			{
				var byte:uint = buffer[i];
				buffer[i] = (byte ^ keyList[keyIndex]) - offset;
				keyIndex = (keyIndex + 1) & 0xF;
				offset = (byte + 0x3D) & 0xFF;
			}
		}
		
		public function parse():void
		{
			buffer.position = 4;
			switch(buffer[3]){
				case 0xA:
					break;
				case 0xC:
					buffer.readUnsignedInt();//encode part size
					decodeBmd();
					break;
				default:
					throw new Error("unsupport version:" + buffer[3]);
			}
			
			readFixedString(buffer, 32);//file name
			
			const subMeshCount:int = buffer.readUnsignedShort();//网格数量
			const boneCount:uint = buffer.readUnsignedShort();//骨骼数量
			const animationCount:int = buffer.readUnsignedShort();//动画数量
			
			if(boneCount == 1 && animationCount == boneCount){
				isStaticMesh = true;
			}
			
			var i:int;
			
			for(i=0; i<subMeshCount; i++){
				readSubMesh();
			}
			
			for(i=0; i<animationCount; i++){
				const keyFrameCount:int = buffer.readUnsignedShort();
				if(isStaticMesh && keyFrameCount > 1){
					isStaticMesh = false;
				}
				var animation:Animation = new Animation(i.toString(), keyFrameCount);
				skeleton.addAnimation(animation);
				if(buffer.readUnsignedByte() == 0){
					continue;
				}
				var offset:Vector.<Vector3D> = new Vector.<Vector3D>(keyFrameCount, true);//位移
				for(var j:int=0; j<keyFrameCount; j++){
					offset[j] = new Vector3D(buffer.readFloat(), buffer.readFloat(), buffer.readFloat());
				}
			}
			
			for(i=0; i<boneCount; i++){
				if(buffer.readUnsignedByte() == 0){
					readBone(i);
				}
			}
			
			skeleton.onInit();
			
			if(buffer.bytesAvailable > 0){
				throw new Error("BMD数据解析失败!");
			}
			
			if(false == isStaticMesh){
				return;
			}
			mesh.skeleton = null;
			var keyFrameMatrix:Matrix3D = new Matrix3D();
			lastKeyFrameTransform.toMatrix(keyFrameMatrix);
			for each(var subMesh:SubMesh in mesh.subMeshes){
				subMesh.geometry.boneData = null;
				var posData:Vector.<Number> = subMesh.geometry.getPosData();
				keyFrameMatrix.transformVectors(posData, posData);
			}
			lastKeyFrameTransform.translation.setTo(0, 0, 0);
			lastKeyFrameTransform.toMatrix(keyFrameMatrix);
			for each(subMesh in mesh.subMeshes){
				subMesh.geometry.boneData = null;
				var normalData:Vector.<Number> = subMesh.geometry.normalData;
				keyFrameMatrix.transformVectors(normalData, normalData);
			}
		}
		
		private function readBone(id:int):void
		{
			skeleton.addBone(new Bone(readFixedString(buffer, 32), id));
			skeleton.setBoneParent(id, buffer.readShort());
			
			for(var i:int=0, n:int=skeleton.getAnimationAmount(); i<n; i++){
				readAnimation(id, skeleton.getAnimationByName(i.toString()));
			}
		}
		
		private function readAnimation(boneId:int, animation:Animation):void
		{
			const n:int = animation.length;
			var i:int;
			
			var flag:Boolean = n > 1;//复制第一桢到末尾
			
			var keyFrames:Vector.<KeyFrame> = new Vector.<KeyFrame>(n+flag, true);
			var keyFrame:KeyFrame;
			
			for(i=0; i<n; i++){
				keyFrame = new KeyFrame(i);
				keyFrames[i] = keyFrame;
				lastKeyFrameTransform = keyFrame.transform;
			}
			
			if(flag){
				keyFrames[n] = new KeyFrame(n, keyFrames[0].transform);
			}
			
			for(i=0; i<n; i++){
				keyFrame = keyFrames[i];
				keyFrame.transform.translation.setTo(buffer.readFloat(), buffer.readFloat(), buffer.readFloat());
			}
			
			for(i=0; i<n; i++){
				keyFrame = keyFrames[i];
				keyFrame.transform.rotation.fromEulerAngles(buffer.readFloat(), buffer.readFloat(), buffer.readFloat());
			}
			
			animation.addTrack(boneId, keyFrames);
		}
		
		private function readVertex(n:int):Vector.<Number>
		{
			var vertexDict:Vector.<Number> = new Vector.<Number>(n*4, true);
			for(var i:int=0; i<n; i++){
				var index:int = i * 4;
				vertexDict[index] = buffer.readUnsignedShort();//boneIndex
				buffer.position += 2;
				vertexDict[index+1] = buffer.readFloat();
				vertexDict[index+2] = buffer.readFloat();
				vertexDict[index+3] = buffer.readFloat();
			}
			return vertexDict;
		}
		
		private function readNornal(n:int):Vector.<Number>
		{
			var norDict:Vector.<Number> = new Vector.<Number>(n*3, true);
			for(var i:int=0; i<n; i++){
				var index:int = i * 3;
				buffer.position += 4;//boneIndex
				norDict[index] = buffer.readFloat();
				norDict[index+1] = buffer.readFloat();
				norDict[index+2] = buffer.readFloat();
				buffer.position += 4;//第几个nor,从0开始顺序编号
			}
			return norDict;
		}
		
		private function readUV(n:int):Vector.<Number>
		{
			var uvDict:Vector.<Number> = new Vector.<Number>(n*2, true);
			for(var i:int=0; i<n; i++){
				var index:int = i * 2;
				uvDict[index] = buffer.readFloat();
				uvDict[index+1] = buffer.readFloat();
			}
			return uvDict;
		}
		
		private function readTriangle(n:int):Vector.<int>
		{
			var triList:Vector.<int> = new Vector.<int>(n*9, true);
			
			for(var i:int=0; i<n; i++){//每个三角形64字节
				buffer.position += 2;
				var pos0:int = buffer.readUnsignedShort();
				var pos1:int = buffer.readUnsignedShort();
				var pos2:int = buffer.readUnsignedShort();
				buffer.position += 2;
				var nor0:int = buffer.readUnsignedShort();
				var nor1:int = buffer.readUnsignedShort();
				var nor2:int = buffer.readUnsignedShort();
				buffer.position += 2;
				var uv0:int = buffer.readUnsignedShort();
				var uv1:int = buffer.readUnsignedShort();
				var uv2:int = buffer.readUnsignedShort();
				buffer.position += 40;
				
				var index:int = i * 9;
				triList[index]   = pos0;
				triList[index+1] = nor0;
				triList[index+2] = uv0;
				
				triList[index+3] = pos1;
				triList[index+4] = nor1;
				triList[index+5] = uv1;
				
				triList[index+6] = pos2;
				triList[index+7] = nor2;
				triList[index+8] = uv2;
			}
			
			return triList;
		}
		
		private function readSubMesh():void
		{
			const vetrexCount:int = buffer.readUnsignedShort();//顶点数目
			const normalCount:int = buffer.readUnsignedShort();//法线数目
			const uvCount:int = buffer.readUnsignedShort();//uv数目
			const triangleCount:uint = buffer.readUnsignedShort();//三角形数目
			buffer.readUnsignedShort();//第几个subMesh,从0开始往后编号
			
			var vertexDict:Vector.<Number> = readVertex(vetrexCount);
			var norDict:Vector.<Number> = readNornal(normalCount);
			var uvDict:Vector.<Number> = readUV(uvCount);
			var triangleDict:Vector.<int> = readTriangle(triangleCount);
			
			var subMesh:SubMesh = mesh.createSubMesh();
			subMesh.materialName = readFixedString(buffer, 32);
			
			const vertextCount:int = triangleCount * 3;
			var geometry:Geometry = new Geometry(vertextCount);
			var indexBuffer:Vector.<uint> = new Vector.<uint>(vertextCount);
			
			var boneData:BoneData = new BoneData(vertextCount);

			for(var i:int=0; i<vertextCount; i++){
				var index:int = i * 3;
				var t1:int = 4 * triangleDict[index];//pos
				var t2:int = 2 * triangleDict[index+2];//uv
				var t3:int = 3 * triangleDict[index+1];//normal
				boneData.assignBone(i, vertexDict[t1], 1);
				geometry.posData[i*3  ] = vertexDict[t1+1];
				geometry.posData[i*3+1] = vertexDict[t1+2];
				geometry.posData[i*3+2] = vertexDict[t1+3];
				geometry.normalData[i*3  ] = norDict[t3];
				geometry.normalData[i*3+1] = norDict[t3+1];
				geometry.normalData[i*3+2] = norDict[t3+2];
				geometry.uvData[i*2  ] = uvDict[t2];
				geometry.uvData[i*2+1] = uvDict[t2+1];
				indexBuffer[i] = i;
			}
			
			boneData.adjustBoneWeight();
			geometry.indexData = indexBuffer;
			geometry.boneData = boneData;
			geometry.calculateBound();
			
			subMesh.geometry = geometry;
//			trace("骨骼数量:", geometry.numBones, "材质名称:", subMesh.materialName);
		}
	}
}