package snjdck.gpu.projection
{
	/**
	 * 平行投影,left hand
	 */	
	final public class OrthoProjection3D extends Projection3D
	{
		public function OrthoProjection3D()
		{
			setDepthCliping(-1000, 4000);
			transform[7] = 1;
		}
		
		public function resize(width:int, height:int):void
		{
			scaleX = 2 / width;
			scaleY = 2 / height;
		}
		
		override public function setDepthCliping(zNear:Number, zFar:Number):void
		{
			transform[2] = 1.0 / (zFar - zNear);
			super.setDepthCliping(zNear, zFar);
		}
	}
}