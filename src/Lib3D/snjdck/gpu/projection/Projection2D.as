package snjdck.gpu.projection
{
	import snjdck.gpu.asset.GpuContext;

	final public class Projection2D
	{
		protected const transform:Vector.<Number> = new Vector.<Number>(4, true);
		
		private var _offsetX:Number;
		private var _offsetY:Number;
		
		public function Projection2D()
		{
			offset(0, 0);
		}
		
		public function upload(context3d:GpuContext):void
		{
			context3d.setVc(0, transform, 1);
		}
		
		public function resize(width:int, height:int):void
		{
			transform[0] =  2.0 / width;
			transform[1] = -2.0 / height;
		}
		
		public function offset(dx:Number, dy:Number):void
		{
			_offsetX = dx;
			_offsetY = dy;
			transform[2] = transform[0] * dx - 1.0;
			transform[3] = transform[1] * dy + 1.0;
		}
		
		public function get offsetX():Number
		{
			return _offsetX;
		}
		
		public function get offsetY():Number
		{
			return _offsetY;
		}
	}
}