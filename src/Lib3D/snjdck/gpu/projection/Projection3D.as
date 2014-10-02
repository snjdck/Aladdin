package snjdck.gpu.projection
{
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.pickup.Ray;
	import snjdck.gpu.asset.GpuContext;

	public class Projection3D
	{
		protected const transform:Vector.<Number> = new Vector.<Number>(8, true);
		
		protected var scaleX:Number;
		protected var scaleY:Number;
		
		private var _zNear:Number = 1;
		
		public function Projection3D(){}
		
		public function setDepthCliping(zNear:Number, zFar:Number):void
		{
			_zNear = zNear;
			transform[6] = transform[2] * -zNear;
		}
		
		final public function upload(context3d:GpuContext, camera:Camera3D):void
		{
			transform[0] = scaleX * camera.viewportRect.width;
			transform[1] = scaleY * camera.viewportRect.height;
			transform[4] = camera.viewportRect.width  + 2 * camera.viewportRect.x - 1;
			transform[5] = camera.viewportRect.height - 2 * camera.viewportRect.y - 1;
			context3d.setVc(0, transform, 2);
		}
		
		final public function getViewRay(screenX:Number, screenY:Number, ray:Ray):void
		{
			var viewW:Number = _zNear * transform[3] + transform[7];
			var viewX:Number = (screenX - transform[4]) / transform[0] * viewW;
			var viewY:Number = (screenY - transform[5]) / transform[1] * viewW;
			
			ray.pos.setTo(viewX, viewY, _zNear);
			ray.dir.setTo(viewX * transform[3], viewY * transform[3], _zNear);
		}
	}
}