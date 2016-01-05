package snjdck.gpu.render.instance
{
	import snjdck.gpu.asset.GpuVertexBuffer;

	internal class BaseVertexData
	{
		protected var data32perVertex:int;
		private var vertexPerInstance:int;
		protected const vertexData:Vector.<Number> = new Vector.<Number>();
		protected var maxInstanceCount:int;
		private var vertexBuffer:GpuVertexBuffer;
		
		public function BaseVertexData(data32perVertex:int, vertexPerInstance:int)
		{
			this.data32perVertex = data32perVertex;
			this.vertexPerInstance = vertexPerInstance;
		}
		
		public function getGpuData(instanceCount:int):GpuVertexBuffer
		{
			if(maxInstanceCount < instanceCount){
				adjustData(instanceCount);
				maxInstanceCount = instanceCount;
				if(vertexBuffer != null)
					vertexBuffer.dispose();
				vertexBuffer = new GpuVertexBuffer(instanceCount * vertexPerInstance, data32perVertex);
				vertexBuffer.upload(vertexData);
			}
			return vertexBuffer;
		}
		
		virtual protected function adjustData(instanceCount:int):void
		{
		}
	}
}