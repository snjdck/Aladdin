package snjdck.g3d.parser
{
	import flash.display3D.Context3DVertexBufferFormat;
	
	import array.copy;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.mesh.BoneData;
	import snjdck.g3d.skeleton.BoneStateGroup;
	import snjdck.gpu.asset.GpuAssetFactory;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	
	use namespace ns_g3d;
	
	public class Geometry implements IGeometry
	{
		static public const PROJECTION_MATRIX_OFFSET:int = 0;
		static public const CAMERA_MATRIX_OFFSET:int = 2;
		static public const WORLD_MATRIX_OFFSET:int = 5;
		static public const BONE_MATRIX_OFFSET:int = 8;
		
		private var _vertexCount:uint;
		private var _faceCount:uint;
		
		private var posData:Vector.<Number>;
		private var uvData:Vector.<Number>;
		private var indexData:Vector.<uint>;
		
		private var gpuPosBuffer:GpuVertexBuffer;
		private var gpuUvBuffer:GpuVertexBuffer;
		private var gpuIndexBuffer:GpuIndexBuffer;
		
		private const _bound:AABB = new AABB();
		
		ns_g3d var boneData:BoneData;
		
		public function Geometry(vertexData:Vector.<Number>, indexData:Vector.<uint>, boneData:BoneData=null)
		{
			this._vertexCount = vertexData.length / 5;
			this._faceCount = indexData.length / 3;
			
			this.posData = new Vector.<Number>(vertexCount*3, true);
			this.uvData = new Vector.<Number>(vertexCount*2, true);
			this.indexData = indexData;
			
			for(var i:int=0; i<vertexCount; i++){
				array.copy(vertexData, posData, 3, i*5, i*3);
				array.copy(vertexData, uvData, 2, i*5+3, i*2);
			}
			
			this.boneData = boneData || new BoneData(vertexCount);
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
			var minX:Number=Number.MAX_VALUE, maxX:Number=Number.MIN_VALUE;
			var minY:Number=Number.MAX_VALUE, maxY:Number=Number.MIN_VALUE;
			var minZ:Number=Number.MAX_VALUE, maxZ:Number=Number.MIN_VALUE;
			
			for(var i:int=0, n:int=posData.length; i<n; i+=3){
				var vx:Number = posData[i];
				var vy:Number = posData[i+1];
				var vz:Number = posData[i+2];
				
				if(vx < minX)	minX = vx;
				if(vx > maxX)	maxX = vx;
				if(vy < minY)	minY = vy;
				if(vy > maxY)	maxY = vy;
				if(vz < minZ)	minZ = vz;
				if(vz > maxZ) 	maxZ = vz;
			}
			
			_bound.setMinMax(minX, minY, minZ, maxX, maxY, maxZ);
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
			if(boneData != null){
				boneData.uploadBoneData(context3d, boneStateGroup);
			}
			context3d.drawTriangles(gpuIndexBuffer);
		}
	}
}