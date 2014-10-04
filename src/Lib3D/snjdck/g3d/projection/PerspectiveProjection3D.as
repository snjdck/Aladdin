package snjdck.g3d.projection
{
	import stdlib.constant.Unit;

	public class PerspectiveProjection3D extends Projection3D
	{
		public function PerspectiveProjection3D()
		{
			setDepthCliping(1, 2);
			transform[3] = 1;
		}
		
		public function fov(fieldOfViewY:Number, aspectRatio:Number):void
		{
			scaleY = 1.0 / Math.tan(0.5 * fieldOfViewY * Unit.RADIAN);
			scaleX = scaleY * aspectRatio;
		}
		
		override public function setDepthCliping(zNear:Number, zFar:Number):void
		{
			transform[2] = zFar / (zFar - zNear);
			super.setDepthCliping(zNear, zFar);
		}
	}
}