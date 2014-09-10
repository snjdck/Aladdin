package snjdck.gpu.projection
{
	import snjdck.gpu.asset.GpuContext;

	/**
	 * 平行投影,left hand
	 */	
	final public class OrthoProjection3D implements IProjection
	{
		private const transform:Vector.<Number> = new Vector.<Number>(8, true);
		
		public function OrthoProjection3D()
		{
			setDepthCliping(4000, -1000);
		}
		
		public function upload(context3d:GpuContext):void
		{
			context3d.setVc(0, transform, 2);
		}
		
		public function resize(width:int, height:int):void
		{
			transform[2] = 2.0 / width;
			transform[3] = 2.0 / height;
		}
		
		public function setDepthCliping(zFar:Number, zNear:Number):void
		{
			transform[6] = 1.0 / (zFar - zNear);
			transform[7] = zNear / (zNear - zFar);
		}
		
		public function offset(dx:Number, dy:Number):void
		{
			transform[0] = dx;
			transform[1] = dy;
		}
	}
}