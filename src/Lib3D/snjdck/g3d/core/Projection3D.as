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
		
		private const transform:Vector.<Number> = new Vector.<Number>(8, true);
		
		public function Projection3D()
		{
			transform[2] = 1.0 / (zFar - zNear);
			transform[6] = transform[2] * -zNear;
		}
		
		public function resize(width:int, height:int):void
		{
			transform[0] = 2 / width;
			transform[1] = 2 / height;
		}
		
		public function upload(context3d:GpuContext):void
		{
			context3d.setVc(0, transform, 2);
		}
		
		public function setViewport(x:Number, y:Number, width:int, height:int):void
		{
			transform[4] = (x + width * 0.5) * transform[0] - 1;
			transform[5] = 1 - (y + height * 0.5) * transform[1];
		}
		
		public function resetViewport():void
		{
			transform[4] = transform[5] = 0;
		}
	}
}