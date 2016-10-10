package snjdck.g3d.parser
{
	import flash.display3D.Context3DVertexBufferFormat;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.mesh.BoneData;
	import snjdck.g3d.skeleton.BoneStateGroup;
	import snjdck.gpu.asset.GpuAssetFactory;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.model3d.calcVertexBound;
	
	use namespace ns_g3d;
	
	public class Geometry implements IGeometry
	{
		static public const WORLD_MATRIX_OFFSET:int = 5;
		static public const BONE_MATRIX_OFFSET:int = 8;
		
		private var _vertexCount:int;
		
		public var posData:Vector.<Number>;
		public var normalData:Vector.<Number>;
		public var uvData:Vector.<Number>;
		public var indexData:Vector.<uint>;
		
		private var gpuPosBuffer:GpuVertexBuffer;
		private var gpuNormalBuffer:GpuVertexBuffer;
		private var gpuUvBuffer:GpuVertexBuffer;
		private var gpuIndexBuffer:GpuIndexBuffer;
		
		private const _bound:AABB = new AABB();
		
		ns_g3d var boneData:BoneData;
		
		public function Geometry(vertexCount:int)
		{
			this._vertexCount = vertexCount;
			
			posData = new Vector.<Number>(vertexCount*3, true);
			normalData = new Vector.<Number>(vertexCount*3, true);
			uvData = new Vector.<Number>(vertexCount*2, true);
		}
		
		public function getPosData():Vector.<Number>
		{
			return posData;
		}
		
		public function dispose():void
		{
			if(gpuPosBuffer){
				gpuPosBuffer.dispose();
				gpuPosBuffer = null;
			}
			if(gpuNormalBuffer){
				gpuNormalBuffer.dispose();
				gpuNormalBuffer = null;
			}
			if(gpuUvBuffer){
				gpuUvBuffer.dispose();
				gpuUvBuffer = null;
			}
			if(gpuIndexBuffer){
				gpuIndexBuffer.dispose();
				gpuIndexBuffer = null;
			}
			posData = null;
			uvData = null;
			indexData = null;
			boneData.dispose();
			boneData = null;
			
		}
		
		public function get vertexCount():uint
		{
			return _vertexCount;
		}
		
		public function calculateBound():void
		{
			calcVertexBound(posData, _bound);
		}
		
		public function get bound():AABB
		{
			return _bound;
		}
		
		public function get numBones():int
		{
			return boneData ? boneData.numBones : 0;
		}
		
		final public function draw(context3d:GpuContext, boneStateGroup:BoneStateGroup):void
		{
			if(null == gpuPosBuffer){
				gpuPosBuffer = GpuAssetFactory.CreateGpuVertexBuffer(posData, 3);
			}
			if(null == gpuNormalBuffer){
				gpuNormalBuffer = GpuAssetFactory.CreateGpuVertexBuffer(normalData, 3);
			}
			if(null == gpuUvBuffer){
				gpuUvBuffer = GpuAssetFactory.CreateGpuVertexBuffer(uvData, 2);
			}
			if(null == gpuIndexBuffer){
				gpuIndexBuffer = GpuAssetFactory.CreateGpuIndexBuffer(indexData);
			}
			context3d.setVertexBufferAt(0, gpuPosBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			if(context3d.isVaSlotInUse(1)){
				context3d.setVertexBufferAt(1, gpuUvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			}
			if(context3d.isVaSlotInUse(4)){
				context3d.setVertexBufferAt(4, gpuNormalBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			}
			if(context3d.isVaSlotInUse(2) && boneData != null){
				boneData.uploadBoneData(context3d, boneStateGroup);
			}
			context3d.drawTriangles(gpuIndexBuffer);
			
			context3d.markRecoverableGpuAsset(gpuPosBuffer);
			context3d.markRecoverableGpuAsset(gpuNormalBuffer);
			context3d.markRecoverableGpuAsset(gpuUvBuffer);
			context3d.markRecoverableGpuAsset(gpuIndexBuffer);
		}
	}
}