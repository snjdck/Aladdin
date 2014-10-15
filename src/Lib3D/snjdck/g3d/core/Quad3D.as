package snjdck.g3d.core
{
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuIndexBuffer;
	import snjdck.gpu.asset.GpuVertexBuffer;

	public class Quad3D extends Object3D
	{
		static private var gpuVertexBuffer:GpuVertexBuffer;
		static private var gpuIndexBuffer:GpuIndexBuffer;
		static private var isGpuBufferInited:Boolean;
		
		private function initGpuBuffer(context3d:GpuContext):void
		{
			if(isGpuBufferInited){
				return;
			}
			isGpuBufferInited = true;
			
			gpuVertexBuffer = new GpuVertexBuffer(4, 2);
			gpuVertexBuffer.upload(new <Number>[-0.5, 0.5, 0.5, 0.5, 0.5, -0.5, -0.5, -0.5]);
			
			gpuIndexBuffer = new GpuIndexBuffer(6);
			gpuIndexBuffer.upload(new <uint>[0,1,2,0,2,3]);
		}
		
		public function Quad3D()
		{
			super();
		}
	}
}