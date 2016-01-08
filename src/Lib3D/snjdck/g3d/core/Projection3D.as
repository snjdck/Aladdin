package snjdck.g3d.core
{
	import snjdck.gpu.asset.GpuContext;
	
	/**
	 * 平行投影,left hand
	 */
	internal class Projection3D
	{
		static public const zNear	:Number = -10000;
		static public const zFar	:Number =  10000;
		
		private const transform:Vector.<Number> = new Vector.<Number>(4, true);
		
		public function Projection3D()
		{
			transform[2] = 1.0 / (zFar - zNear);
			transform[3] = -zNear;
		}
		
		public function resize(width:int, height:int):void
		{
			transform[0] = 2 / width;
			transform[1] = 2 / height;
		}
		
		public function upload(context3d:GpuContext):void
		{
			context3d.setVc(0, transform, 1);
		}
		
		public function copyTo(output:Vector.<Number>):void
		{
			for(var i:int=0; i<4; ++i)
				output[i] = transform[i];
		}
	}
}