package snjdck.gpu.projection
{
	import snjdck.gpu.asset.GpuContext;

	/**
	 * 平行投影,left hand
	 */	
	final public class OrthoProjection
	{
		private const transform:Vector.<Number> = new Vector.<Number>(16, true);
		
		public function OrthoProjection()
		{
			transform[0] = 1;
			transform[5] = 1;
			transform[10] = 1;
			transform[15] = 1;
		}
		
		public function resize(w:Number, h:Number):void
		{
			transform[0] = 2.0 / w;
			transform[5] = 2.0 / h;
		}
		
		public function setDepthCliping(zFar:Number, zNear:Number):void
		{
			transform[10] = 1.0 / (zFar - zNear);
			transform[11] = zNear / (zNear - zFar);
		}
		
		public function upload(context3d:GpuContext):void
		{
			context3d.setVc(0, transform, 4);
		}
		
		public function offset(dx:Number, dy:Number):void
		{
			transform[3] = transform[0] * dx;
			transform[7] = transform[5] * dy;
		}
	}
}