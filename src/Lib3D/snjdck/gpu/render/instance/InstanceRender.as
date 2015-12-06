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
		
		private const vertexData:VertexData = new VertexData();
		private const indexData:IndexData = new IndexData();
		
		private const constData:Vector.<Number> = new Vector.<Number>(1000, true);
		
		public function InstanceRender(){}
		
		public function setVc(render:Render2D, worldMatrix:Matrix):void
		{
			render.copyProjectData(constData);
			if(worldMatrix != null)
				matrix33.toBuffer(worldMatrix, constData, 4);
		}
		
		public function draw(context3d:GpuContext, instanceData:IInstanceData):void
		{
			var numRegisterPerInstance:int = instanceData.numRegisterPerInstance;
			var instanceCountPerBatch:int = (MAX_VC_COUNT - RESERVE_VC_COUNT) / numRegisterPerInstance;
			var totalInstanceCount:int = instanceData.numInstances;
			var batchCount:int = Math.ceil(totalInstanceCount / instanceCountPerBatch);
			var maxQuadCount:int = Math.min(totalInstanceCount, instanceCountPerBatch);
			var vertexBuffer:GpuVertexBuffer = vertexData.getGpuData(maxQuadCount);
			var indexBuffer:GpuIndexBuffer = indexData.getGpuData(maxQuadCount);
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			instanceData.initConstData(constData);
			for(var i:int=0; i<batchCount; ++i){
				var fromIndex:int = i * instanceCountPerBatch;
				var count:int = Math.min(instanceCountPerBatch, totalInstanceCount - fromIndex);
				instanceData.updateConstData(constData, fromIndex, count);
				context3d.setVc(0, constData, RESERVE_VC_COUNT + numRegisterPerInstance * count);
				context3d.drawTriangles(indexBuffer, 0, count << 1);
			}
		}
	}
}