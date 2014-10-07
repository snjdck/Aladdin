package snjdck.g3d.projection
{
	import flash.geom.Vector3D;
	
	import stdlib.constant.Unit;

	final public class PerspectiveProjection3D extends Projection3D
	{
		public function PerspectiveProjection3D()
		{
			transform[3] = 1;
		}
		
		public function fov(fieldOfViewY:Number, aspectRatio:Number):void
		{
			scaleY = 1.0 / Math.tan(0.5 * fieldOfViewY * Unit.RADIAN);
			scaleX = scaleY / aspectRatio;
		}
		
		override public function setDepthCliping(zNear:Number, zFar:Number):void
		{
			transform[2] = zFar / (zFar - zNear);
			super.setDepthCliping(zNear, zFar);
		}
		
		override public function scene2screen(input:Vector3D, output:Vector3D):void
		{
			var factor:Number = 1 / input.z;
			output.x = input.x * transform[0] * factor + transform[4];
			output.y = input.y * transform[1] * factor + transform[5];
			output.z = transform[2] + transform[6] * factor;
		}
		
		override public function screen2scene(input:Vector3D, output:Vector3D):void
		{
			output.z = transform[6] / (input.z - transform[2]);
			output.x = (input.x - transform[4]) / transform[0] * output.z;
			output.y = (input.y - transform[5]) / transform[1] * output.z;
		}
	}
}