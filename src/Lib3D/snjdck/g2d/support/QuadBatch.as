package snjdck.g2d.support
{
	import flash.display3D.Context3DBufferUsage;
	import flash.display3D.Context3DVertexBufferFormat;
	
	import array.copy;
	
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.gpu.asset.IGpuTexture;
	import snjdck.gpu.asset.GpuAssetFactory;

	final public class QuadBatch
	{
		private var maxQuadCount:int;
		
		private var vertexBuffer:Vector.<Number>;
		private var indexBuffer:Vector.<uint>;
		private var quadCount:int;
		
		private var gpuVertexBuffer:GpuVertexBuffer;
		private var gpuIndexBuffer:GpuIndexBuffer;
		private var isGpuBufferDirty:Boolean;
		
		public function QuadBatch()
		{
			vertexBuffer = new Vector.<Number>();
			indexBuffer = new Vector.<uint>();
		}
		
		public function clear():void
		{
			quadCount = 0;
		}
		
		public function addQuad(quad:VertexData):void
		{
			if(maxQuadCount <= quadCount)
			{
				var offset:int = 4 * maxQuadCount;
				indexBuffer.push(offset, offset+1, offset+2, offset, offset+2, offset+3);
				++maxQuadCount;
				isGpuBufferDirty = true;
			}
			
			array.copy(quad.getRawData(), vertexBuffer, VertexData.DATA32_PER_QUAD, 0, quadCount * VertexData.DATA32_PER_QUAD);
			
			++quadCount;
		}
		
		public function draw(context3d:GpuContext, gpuTexture:IGpuTexture):void
		{
			if(quadCount <= 0){
				return;
			}
			
			updateGpuBuffer();
			
			gpuVertexBuffer.upload(vertexBuffer, quadCount * 4);
			
			if(null == gpuTexture){
				context3d.setVertexBufferAt(0, gpuVertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			}else{
				context3d.setVertexBufferAt(0, gpuVertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				context3d.setVertexBufferAt(1, gpuVertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
				context3d.setVertexBufferAt(2, gpuVertexBuffer, 5, Context3DVertexBufferFormat.FLOAT_4);
				context3d.setTextureAt(0, gpuTexture);
			}
			
			context3d.drawTriangles(gpuIndexBuffer, 0, quadCount * 2);
		}
		
		private function updateGpuBuffer():void
		{
			if(false == isGpuBufferDirty){
				return;
			}
			isGpuBufferDirty = false;
			
			if(gpuVertexBuffer){
				gpuVertexBuffer.dispose();
			}
			gpuVertexBuffer = GpuAssetFactory.CreateGpuVertexBuffer2(maxQuadCount * 4, VertexData.DATA32_PER_VERTEX, Context3DBufferUsage.DYNAMIC_DRAW);
			
			if(gpuIndexBuffer){
				gpuIndexBuffer.dispose();
			}
			gpuIndexBuffer = GpuAssetFactory.CreateGpuIndexBuffer(indexBuffer);
		}
	}
}