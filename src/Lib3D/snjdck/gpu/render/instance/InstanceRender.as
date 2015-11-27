package snjdck.gpu.render.instance
{
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix;
	
	import matrix33.toBuffer;
	
	import snjdck.g2d.render.Render2D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	
	final public class InstanceRender
	{
		static public const Instance:InstanceRender = new InstanceRender();
		static public var MAX_VC_COUNT:int = 128;
		static private const RESERVE_VC_COUNT:int = 4;
		
		private const data32perVertex:int = 3;
		private const data32perQuad:int = data32perVertex << 2;
		
		private var vertexBuffer:GpuVertexBuffer;
		private const vertexData:Vector.<Number> = new Vector.<Number>();
		
		private var indexBuffer:GpuIndexBuffer;
		private const indexData:Vector.<uint> = new Vector.<uint>();
		
		private var maxQuadCount:int;
		
		private const constData:Vector.<Number> = new Vector.<Number>(1000, true);
		
		public function InstanceRender(){}
		
		protected function adjustData(quadCount:int):void
		{
			if(maxQuadCount >= quadCount){
				return;
			}
			
			adjustVertexData(quadCount);
			adjustIndexData(quadCount);
			
			maxQuadCount = quadCount;
			
			if(vertexBuffer != null){
				vertexBuffer.dispose();
			}
			if(indexBuffer != null){
				indexBuffer.dispose();
			}
			
			vertexBuffer = new GpuVertexBuffer(quadCount << 2, data32perVertex);
			vertexBuffer.upload(vertexData);
			
			indexBuffer = new GpuIndexBuffer(indexData.length);
			indexBuffer.upload(indexData);
		}
		
		private function adjustVertexData(quadCount:int):void
		{
			vertexData.length = quadCount * data32perQuad;
			var offset:int = maxQuadCount * data32perQuad;
			for(var i:int=maxQuadCount; i<quadCount; ++i){
				vertexData[offset+2] = i;
				offset += data32perVertex;
				vertexData[offset] = 1;
				vertexData[offset+2] = i;
				offset += data32perVertex;
				vertexData[offset+1] = 1;
				vertexData[offset+2] = i;
				offset += data32perVertex;
				vertexData[offset] = 1;
				vertexData[offset+1] = 1;
				vertexData[offset+2] = i;
				offset += data32perVertex;
			}
		}
		
		private function adjustIndexData(quadCount:int):void
		{
			var offset:int = indexData.length;
			indexData.length = quadCount * 6;
			for(var i:int=maxQuadCount; i<quadCount; ++i){
				var index:int = i << 2;
				indexData[offset++] = index;
				indexData[offset++] = index + 1;
				indexData[offset++] = index + 3;
				indexData[offset++] = index;
				indexData[offset++] = index + 3;
				indexData[offset++] = index + 2;
			}
		}
		
		public function setVc(render:Render2D, worldMatrix:Matrix):void
		{
			render.copyProjectData(constData);
			matrix33.toBuffer(worldMatrix, constData, 4);
		}
		
		public function draw(context3d:GpuContext, instanceData:IInstanceData):void
		{
			var numRegisterPerInstance:int = instanceData.numRegisterPerInstance;
			var instanceCountPerBatch:int = (MAX_VC_COUNT - RESERVE_VC_COUNT) / numRegisterPerInstance;
			var totalInstanceCount:int = instanceData.numInstances;
			var batchCount:int = Math.ceil(totalInstanceCount / instanceCountPerBatch);
			adjustData(Math.min(totalInstanceCount, instanceCountPerBatch));
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			instanceData.initConstData(constData);
			for(var i:int=0; i<batchCount; ++i){
				var fromIndex:int = i * instanceCountPerBatch;
				var count:int = Math.min(instanceCountPerBatch, totalInstanceCount - fromIndex);
				instanceData.updateConstData(constData, fromIndex, count);
				context3d.setVc(0, constData, RESERVE_VC_COUNT+numRegisterPerInstance*count);
				context3d.drawTriangles(indexBuffer, 0, count << 1);
			}
		}
	}
}