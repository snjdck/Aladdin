package snjdck.g3d.parser
{
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import array.copy;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.skeleton.BoneStateGroup;
	import snjdck.gpu.asset.GpuAssetFactory;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.shader.ShaderName;
	
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
		
		public function Geometry(vertexData:Vector.<Number>, indexData:Vector.<uint>)
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
		}
		
		public function getPosData():Vector.<Number>
		{
			return posData;
		}
		
		public function getUvData():Vector.<Number>
		{
			return uvData;
		}
		
		public function getIndexData():Vector.<uint>
		{
			return indexData;
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
		}
		
		public function get vertexCount():uint
		{
			return _vertexCount;
		}
		/*
		public function setVertex(vertexIndex:int, vx:Number, vy:Number, vz:Number, u:Number, v:Number):void
		{
			setPos(vertexIndex, vx, vy, vz);
			setUV(vertexIndex, u, v);
		}
		
		public function setPos(vertexIndex:int, vx:Number, vy:Number, vz:Number):void
		{
			const offset:int = vertexIndex * 3;
			posData[offset] = vx;
			posData[offset+1] = vy;
			posData[offset+2] = vz;
		}
		
		public function setUV(vertexIndex:int, u:Number, v:Number):void
		{
			const offset:int = vertexIndex * 2;
			uvData[offset] = u;
			uvData[offset+1] = v;
		}
		*/
		
		protected function testRayImp(ray:Ray, mouseLocation:Vector3D, vertexBuffer:Vector.<Number>):Boolean
		{
			/*
			var v0:Vector3D = new Vector3D();
			var v1:Vector3D = new Vector3D();
			var v2:Vector3D = new Vector3D();
			
			for(var i:int=0, n:int=indexData.length; i<n; i+=3){
				getVertex(indexData[i],  v0, vertexBuffer);
				getVertex(indexData[i+1],v1, vertexBuffer);
				getVertex(indexData[i+2],v2, vertexBuffer);
				
				if(ray.testTriangle(v0, v1, v2, result)){
					return true;
				}
			}
			*/
			return false;
		}
		
		public function testRay(ray:Ray, mouseLocation:Vector3D, boneStateGroup:BoneStateGroup):Boolean
		{
			return testRayImp(ray, mouseLocation, posData);
		}
		
		public function getVertex(vertexIndex:uint, result:Vector3D, buffer:Vector.<Number>=null):void
		{
			const offset:int = vertexIndex * 3;
			buffer ||= posData;
			result.setTo(buffer[offset], buffer[offset+1], buffer[offset+2]);
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
			return 0;
		}
		/*
		protected function uploadVertexData(data:Vector.<Number>):void
		{
			gpuPosBuffer.upload(data);
		}
		*/
		final public function draw(context3d:GpuContext, worldMatrix:Matrix3D, boneStateGroup:BoneStateGroup):void
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
			onDraw(context3d, worldMatrix, boneStateGroup);
			context3d.setVertexBufferAt(0, gpuPosBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3d.setVertexBufferAt(1, gpuUvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3d.drawTriangles(gpuIndexBuffer);
		}
		
		protected function onDraw(context3d:GpuContext, worldMatrix:Matrix3D, boneStateGroup:BoneStateGroup):void
		{
			context3d.setVcM(WORLD_MATRIX_OFFSET, worldMatrix);
		}
	}
}