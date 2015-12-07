package snjdck.gpu.state
{
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.DepthTest;
	import snjdck.gpu.asset.GpuProgram;
	import snjdck.gpu.register.VertexRegister;

	public class GpuState
	{
		public const vertexRegister:VertexRegister = new VertexRegister();
		
		public var program:GpuProgram;
		public var blendMode:BlendMode;
		
		public var culling:String;
		public const depthTest:DepthTest = new DepthTest();
		
		public function GpuState(){}
		
		public function clear():void
		{
			vertexRegister.clear();
			program = null;
		}
	}
}