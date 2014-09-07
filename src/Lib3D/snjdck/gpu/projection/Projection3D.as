package snjdck.gpu.projection
{
	import snjdck.gpu.asset.GpuContext;

	internal class Projection3D
	{
		protected const transform:Vector.<Number> = new Vector.<Number>(16, true);
		
		public function Projection3D()
		{
			transform[0] = 1;
			transform[5] = 1;
			transform[10] = 1;
			transform[15] = 1;
		}
		
		public function upload(context3d:GpuContext):void
		{
			context3d.setVc(0, transform, 4);
		}
	}
}