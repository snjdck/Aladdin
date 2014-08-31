package snjdck.gpu.projection
{
	/**
	 * 平行投影,left hand
	 */	
	final public class OrthoProjection3D extends Projection
	{
		public function OrthoProjection3D()
		{
			setDepthCliping(4000, -1000);
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
		
		public function offset(dx:Number, dy:Number):void
		{
			transform[3] = transform[0] * dx;
			transform[7] = transform[5] * dy;
		}
	}
}