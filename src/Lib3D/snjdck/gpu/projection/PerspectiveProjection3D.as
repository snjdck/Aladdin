package snjdck.gpu.projection
{
	public class PerspectiveProjection3D extends Projection3D// implements IProjection
	{
		public function PerspectiveProjection3D()
		{
			setDepthCliping(1, 2);
			transform[3] = 1;
		}
		
		override public function resize(width:int, height:int):void
		{
			transform[0] = _zNear * 2.0 / width;
			transform[1] = _zNear * 2.0 / height;
		}
		
		override public function setDepthCliping(zNear:Number, zFar:Number):void
		{
			transform[2] = zFar / (zFar - zNear);
			super.setDepthCliping(zNear, zFar);
		}
	}
}