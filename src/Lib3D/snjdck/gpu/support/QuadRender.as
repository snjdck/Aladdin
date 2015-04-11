package snjdck.gpu.support
{
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.d3.createMeshIndices;
	
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;

	final public class QuadRender
	{
		static public const Instance:QuadRender = new QuadRender();
		
		private const vertexBuffer:GpuVertexBuffer = new GpuVertexBuffer(16, 6);
		private const indexBuffer:GpuIndexBuffer = new GpuIndexBuffer(54);
		
		public function QuadRender()
		{
			vertexBuffer.upload(new <Number>[
			0, 0, 0,  0, 0, 0,
			0, 0, 1,  0, 0, 0,
			1, 0, 0, -1, 0, 0,
			1, 0, 0,  0, 0, 0,
			
			0, 0, 0,  0, 1, 0,
			0, 0, 1,  0, 1, 0,
			1, 0, 0, -1, 1, 0,
			1, 0, 0,  0, 1, 0,
			
			0, 1, 0,  0, 0, -1,
			0, 1, 1,  0, 0, -1,
			1, 1, 0, -1, 0, -1,
			1, 1, 0,  0, 0, -1,
			
			0, 1, 0,  0, 0, 0,
			0, 1, 1,  0, 0, 0,
			1, 1, 0, -1, 0, 0,
			1, 1, 0,  0, 0, 0
			]);
			var t:Vector.<uint> = new Vector.<uint>();
			createMeshIndices(4, 4, t);
			indexBuffer.upload(t);
		}
		
		public function drawBegin(context3d:GpuContext):void
		{
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3d.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_4);
		}
		
		public function drawTriangles(context3d:GpuContext, useScale9Grid:Boolean=false):void
		{
			if(useScale9Grid){
				context3d.drawTriangles(indexBuffer);
			}else{
				context3d.drawTriangles(indexBuffer, 24, 2);
			}
		}
	}
}