package snjdck.g2d.support
{
	import flash.display3D.Context3DVertexBufferFormat;
	
	import array.copy;
	
	import snjdck.g3d.asset.IGpuContext;
	import snjdck.g3d.asset.IGpuIndexBuffer;
	import snjdck.g3d.asset.IGpuTexture;
	import snjdck.g3d.asset.IGpuVertexBuffer;
	import snjdck.g3d.asset.impl.GpuAssetFactory;

	final public class QuadBatch
	{
		private var maxQuadCount:int;
		
		private var vertexBuffer:Vector.<Number>;
		private var indexBuffer:Vector.<uint>;
		private var quadCount:int;
		
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
		
		private var gpuVertexBuffer:IGpuVertexBuffer;
		private var gpuIndexBuffer:IGpuIndexBuffer;
		private var isGpuBufferDirty:Boolean;
		
		public function draw(context3d:IGpuContext, gpuTexture:IGpuTexture):void
		{
			if(quadCount <= 0){
				return;
			}
			
			if(isGpuBufferDirty){
				if(gpuVertexBuffer){
					gpuVertexBuffer.dispose();
				}
				if(gpuIndexBuffer){
					gpuIndexBuffer.dispose();
				}
				gpuVertexBuffer = GpuAssetFactory.CreateGpuVertexBuffer2(maxQuadCount * 4, VertexData.DATA32_PER_VERTEX);
				gpuIndexBuffer = GpuAssetFactory.CreateGpuIndexBuffer(indexBuffer);
				isGpuBufferDirty = false;
			}
			
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
	}
}