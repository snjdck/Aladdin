package snjdck.g3d.core
{
	/**
	 * 平行投影,left hand
	 */
	public class Projection3D
	{
		static public const zNear	:Number = -10000;
		static public const zFar	:Number =  10000;
		
		private const transform:Vector.<Number> = new Vector.<Number>(4, true);
		
		public function Projection3D()
		{
			transform[2] = zFar - zNear;
			transform[3] = zNear;
		}
		
		public function resize(width:int, height:int):void
		{
			transform[0] = 0.5 * width;
			transform[1] = 0.5 * height;
		}
		
		public function upload(output:Vector.<Number>):void
		{
			for(var i:int=0; i<4; ++i)
				output[i] = transform[i];
		}
	}
}