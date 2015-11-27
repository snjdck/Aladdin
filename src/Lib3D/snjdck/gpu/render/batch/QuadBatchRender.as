package snjdck.gpu.render.batch
{
	import flash.display3D.Context3DVertexBufferFormat;
	
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	
	public class QuadBatchRender
	{
		static protected const data32perVertex:int = 10;
		static protected const data32perQuad:int = data32perVertex << 2;
		
		static private var vertexBuffer:GpuVertexBuffer;
		static protected const vertexData:Vector.<Number> = new Vector.<Number>();
		
		static private var indexBuffer:GpuIndexBuffer;
		static private const indexData:Vector.<uint> = new Vector.<uint>();
		
		static private var maxQuadCount:int;
		
		static protected const constData:Vector.<Number> = new Vector.<Number>(16, true);
		
		public function QuadBatchRender(){}
		
		protected function draw(context3d:GpuContext, quadCount:int):void
		{
			context3d.setVc(0, constData, 4);
			vertexBuffer.upload(vertexData, quadCount << 2);
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3d.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_4);
			if(context3d.isVaSlotInUse(2)){
				context3d.setVertexBufferAt(2, vertexBuffer, 6, Context3DVertexBufferFormat.FLOAT_4);
			}
			context3d.drawTriangles(indexBuffer, 0, quadCount << 1);
		}
		
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
			
			vertexBuffer = new GpuVertexBuffer(quadCount << 2, data32perVertex, true);
			indexBuffer = new GpuIndexBuffer(indexData.length);
			indexBuffer.upload(indexData);
		}
		
		private function adjustVertexData(quadCount:int):void
		{
			vertexData.length = quadCount * data32perQuad;
			for(var i:int=maxQuadCount; i<quadCount; ++i){
				var offset:int = i * data32perQuad;
				vertexData[offset+data32perVertex] =
				vertexData[offset+data32perVertex*2+1] =
				vertexData[offset+data32perVertex*3] =
				vertexData[offset+data32perVertex*3+1] = 1;
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
	}
}