package snjdck.g3d.projection
{
	import flash.geom.Vector3D;
	
	import snjdck.g3d.pickup.Ray;

	/**
	 * 平行投影,left hand
	 */	
	final public class OrthoProjection3D extends Projection3D
	{
		public function OrthoProjection3D()
		{
			transform[7] = 1;
		}
		
		public function resize(width:int, height:int):void
		{
			scaleX = 2 / width;
			scaleY = 2 / height;
		}
		
		override public function getViewRay(screenX:Number, screenY:Number, ray:Ray):void
		{
			var viewX:Number = (screenX - transform[4]) / transform[0];
			var viewY:Number = (screenY - transform[5]) / transform[1];
			
			ray.pos.setTo(viewX, viewY, _zNear);
			ray.dir.setTo(0, 0, 1);
		}
		
		override public function scene2screen(input:Vector3D, output:Vector3D):void
		{
			output.x = input.x * transform[0] + transform[4];
			output.y = input.y * transform[1] + transform[5];
			output.z = input.z * transform[2] + transform[6];
		}
		
		override public function screen2scene(input:Vector3D, output:Vector3D):void
		{
			output.x = (input.x - transform[4]) / transform[0];
			output.y = (input.y - transform[5]) / transform[1];
			output.z = (input.z - transform[6]) / transform[2];
		}
	}
}