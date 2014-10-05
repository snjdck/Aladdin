package snjdck.g3d.projection
{
	import flash.geom.Vector3D;
	
	import snjdck.g3d.core.Viewport;
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
		
		final public function upload(context3d:GpuContext, viewport:Viewport):void
		{
			viewport.adjust(transform, scaleX, scaleY);
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
		
		final public function scene2screen(input:Vector3D, output:Vector3D):void
		{
			output.w = input.z * transform[3] + transform[7];
			output.x = input.x * transform[0];
			output.y = input.y * transform[1];
			output.z = input.z * transform[2] + transform[6];
			output.project();
			output.x += transform[4];
			output.y += transform[5];
		}
	}
}