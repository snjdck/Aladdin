package snjdck.g2d.support
{
	import flash.display3D.Context3DVertexBufferFormat;
	
	import array.copy;
	
	import snjdck.gpu.asset.GpuAssetFactory;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;
	import snjdck.gpu.asset.IGpuTexture;

	final public class QuadBatch
	{
		private var maxQuadCount:int;
		
		private var vertexBuffer:Vector.<Number>;
		private var indexBuffer:Vector.<uint>;
		private var quadCount:int;
		
		private var gpuVertexBuffer:GpuVertexBuffer;
		private var gpuIndexBuffer:GpuIndexBuffer;
		private var isGpuBufferDirty:Boolean;
		
		private var renderStateBatch:RenderStateBatch;
		
		public function QuadBatch()
		{
			vertexBuffer = new Vector.<Number>();
			indexBuffer = new Vector.<uint>();
			renderStateBatch = new RenderStateBatch();
		}
		
		public function clear():void
		{
			renderStateBatch.clear();
			quadCount = 0;
		}
		
		public function addQuad(quad:VertexData, texture:IGpuTexture):void
		{
			renderStateBatch.add(texture);
			
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
		
		public function draw(context3d:GpuContext):void
		{
			if(quadCount <= 0){
				return;
			}
			
			updateGpuBuffer();
			
			gpuVertexBuffer.upload(vertexBuffer, quadCount * 4);
			
			if(context3d.isVaSlotInUse(0)){
				context3d.setVertexBufferAt(0, gpuVertexBuffer, VertexData.OFFSET_XYZ, Context3DVertexBufferFormat.FLOAT_2);
			}
			
			if(context3d.isVaSlotInUse(1)){
				context3d.setVertexBufferAt(1, gpuVertexBuffer, VertexData.OFFSET_UV, Context3DVertexBufferFormat.FLOAT_3);
			}
			
			renderStateBatch.draw(context3d, gpuIndexBuffer);
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
			//gpuVertexBuffer = GpuAssetFactory.CreateGpuVertexBuffer2(maxQuadCount * 4, VertexData.DATA32_PER_VERTEX, Context3DBufferUsage.DYNAMIC_DRAW);
			
			if(gpuIndexBuffer){
				gpuIndexBuffer.dispose();
			}
			gpuIndexBuffer = GpuAssetFactory.CreateGpuIndexBuffer(indexBuffer);
		}
	}
}