package snjdck.g3d.mesh
{
	import flash.geom.Matrix3D;
	import flash.utils.Dictionary;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.asset.IGpuVertexBuffer;
	import snjdck.g3d.asset.impl.GpuAssetFactory;
	import snjdck.g3d.render.DrawUnit3D;
	
	use namespace ns_g3d;
	
	final public class BoneData
	{
		static private function BoneIdToBoneIndex(boneId:int):int
		{
			return BONE_REG_OFFSET + boneId * 3;//每个骨头矩阵占3个寄存器
		}
		
		static private function BoneIndexToBoneId(boneIndex:int):int
		{
			return (boneIndex - BONE_REG_OFFSET) / 3;//每个骨头矩阵占3个寄存器
		}
		
		static private const BONE_REG_OFFSET:int = 8;
		
		static private const MAX_BONE_COUNT_PER_GEOMETRY:int = BoneIndexToBoneId(DrawUnit3D.MAX_VC_COUNT);
		/** 每个顶点绑定的骨骼数量最大为12根 */
		static private const MAX_BONE_COUNT_PER_VERTEX:int = 12;
		static private const data32PerVertex:int = MAX_BONE_COUNT_PER_VERTEX * 2;
		
		private var offsetDict:Vector.<int>;
		private var buffer:Vector.<Number>;
		
		private var gpuBoneBuffer:IGpuVertexBuffer;
		
		private var maxBoneCountPerVertex:int;
		private var boneIds:Vector.<int>;
		
		private var isSealed:Boolean;
		private var vertexDict:Object;
		
		public function BoneData(vertexCount:uint)
		{
			offsetDict = new Vector.<int>(vertexCount, true);
			buffer = new Vector.<Number>(vertexCount * data32PerVertex, true);
			boneIds = new Vector.<int>();
			vertexDict = new Dictionary();
		}
		
		[Inline]
		final public function dispose():void
		{
			if(gpuBoneBuffer){
				gpuBoneBuffer.dispose();
			}
		}
		
		[Inline]
		final public function get numBones():int
		{
			return boneIds.length;
		}
		
		[Inline]
		public function canRenderByGPU():Boolean
		{
			return (numBones <= MAX_BONE_COUNT_PER_GEOMETRY) && (maxBoneCountPerVertex <= MAX_BONE_COUNT_PER_VERTEX);
		}
		
		ns_g3d function assignBone(vertexIndex:uint, boneId:int, weight:Number):void
		{
			assert(false == isSealed, "bone is sealed!");
			
			var boneIdIndex:int = boneIds.indexOf(boneId);
			
			if(-1 == boneIdIndex){
				boneIdIndex = boneIds.length;
				boneIds[boneIdIndex] = boneId;
			}
			
			var vertexBoneCount:int = offsetDict[vertexIndex];
			const index:int = vertexIndex * data32PerVertex + vertexBoneCount * 2;
			offsetDict[vertexIndex] = ++vertexBoneCount;
			
			buffer[index] = BoneIdToBoneIndex(boneIdIndex);
			buffer[index+1] = weight;
			
			if(vertexBoneCount > maxBoneCountPerVertex){
				maxBoneCountPerVertex = vertexBoneCount;
			}
			
			//注册顶点到骨骼
			if(null == vertexDict[boneId]){
				vertexDict[boneId] = [];
			}
			vertexDict[boneId].push(vertexIndex*3, index+1);//顶点数据的起始偏移,权重数据的偏移
		}
		
		public function getDrawUnit(drawUnit:DrawUnit3D, boneDict:Object):void
		{
			if(null == gpuBoneBuffer){
				gpuBoneBuffer = GpuAssetFactory.CreateGpuVertexBuffer(buffer, data32PerVertex);
			}
			drawUnit.setVa2(gpuBoneBuffer, [4, 4, 4, 4, 4, 4], 2);
			for(var i:int=0, n:int=boneIds.length; i<n; i++){
				drawUnit.setBoneMatrix(BoneIdToBoneIndex(i), boneDict[boneIds[i]]);
			}
		}
		
		ns_g3d function createBoneDict(boneDict:Object):void
		{
			for(var i:int=0, n:int=boneIds.length; i<n; i++){
				var boneId:int = boneIds[i];
				if(!(boneId in boneDict)){
					boneDict[boneId] = new Matrix3D();
				}
			}
		}
		
		ns_g3d function adjustBoneWeight():void
		{
			assert(false == isSealed, "bone is sealed!");
			isSealed = true;
			assert(canRenderByGPU(), "bone can't render on gpu!");
			
			for(var vertexIndex:int=0, vertexCount:int=offsetDict.length; vertexIndex < vertexCount; vertexIndex++)
			{
				var bufferOffsetInit:int = vertexIndex * data32PerVertex;
				var boneCount:int = offsetDict[vertexIndex];
				var boneWeightTotal:Number = 0;
				
				for(var boneIndex:int=0; boneIndex < boneCount; boneIndex++)
				{
					var bufferOffset:int = bufferOffsetInit + boneIndex * 2 + 1;
					if(boneIndex == boneCount - 1){
						buffer[bufferOffset] = 1 - boneWeightTotal;
					}else{
						boneWeightTotal += buffer[bufferOffset];
					}
				}
			}
		}
		
		public function transformVertex(input:Vector.<Number>, output:Vector.<Number>, boneDict:Object):void
		{
			for(var i:int=0, n:int=input.length; i<n; i++){
				output[i] = 0;
			}
			
			for(var boneId:* in vertexDict)
			{
				var vertexInfoList:Array = vertexDict[boneId];
				var boneMatrix:Matrix3D = boneDict[boneId];
				
				var globalOffset:int, localOffset:int = 0;
				
				n = vertexInfoList.length;
				
				for(i=0; i<n; i+=2)
				{
					globalOffset = vertexInfoList[i];
					
					tempFloatBuffer[localOffset++] = input[globalOffset];
					tempFloatBuffer[localOffset++] = input[globalOffset+1];
					tempFloatBuffer[localOffset++] = input[globalOffset+2];
				}
				
				tempFloatBuffer.length = localOffset;
				boneMatrix.transformVectors(tempFloatBuffer, tempFloatBuffer);
				
				for(i=n-2; i>=0; i-=2)
				{
					var boneWeight:Number = buffer[vertexInfoList[i+1]];
					globalOffset = vertexInfoList[i];
					
					output[globalOffset+2] += boneWeight * tempFloatBuffer[--localOffset];
					output[globalOffset+1] += boneWeight * tempFloatBuffer[--localOffset];
					output[globalOffset]   += boneWeight * tempFloatBuffer[--localOffset];
				}
			}
		}
		
		static private const tempFloatBuffer:Vector.<Number> = new Vector.<Number>();
	}
}