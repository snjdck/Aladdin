package snjdck.gpu.render.instance
{
	import flash.display3D.Context3DVertexBufferFormat;
	
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;

	internal class QuadGpuData implements IInstanceGpuData
	{
		private const vertexData:QuadVertexData = new QuadVertexData();
		private const indexData:QuadIndexData = new QuadIndexData();
		
		public function QuadGpuData(){}
		
		public function initGpuData(context3d:GpuContext, maxInstanceCount:int):void
		{
			var vertexBuffer:GpuVertexBuffer = vertexData.getGpuData(maxInstanceCount);
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
		}
		
		public function drawTriangles(context3d:GpuContext, instanceCount:int):void
		{
			var indexBuffer:GpuIndexBuffer = indexData.getGpuData(instanceCount);
			context3d.drawTriangles(indexBuffer, 0, instanceCount << 1);
		}
	}
}