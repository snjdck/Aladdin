package snjdck.gpu.state
{
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.asset.GpuProgram;

	internal class GpuState
	{
		private var program:GpuProgram;
		private var blendMode:BlendMode;
		
		public function GpuState()
		{
		}
		
		public function clear():void
		{
			program = null;
		}
		
		public function copyFrom(context3d:GpuContext):void
		{
			program = context3d.program;
			blendMode = context3d.blendMode;
		}
		
		public function applyTo(context3d:GpuContext):void
		{
			context3d.program = program;
			context3d.blendMode = blendMode;
		}
	}
}