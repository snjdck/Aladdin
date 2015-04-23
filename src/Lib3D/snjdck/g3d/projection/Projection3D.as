package snjdck.g3d.projection
{
	import flash.geom.Vector3D;
	
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.viewfrustum.ViewFrustum;
	import snjdck.gpu.asset.GpuContext;

	public class Projection3D
	{
		protected const transform:Vector.<Number> = new Vector.<Number>(8, true);
		
		protected var scaleX:Number;
		protected var scaleY:Number;
		
		protected var _zNear:Number;
		protected var _zFar:Number;
		
		public var viewFrustum:ViewFrustum;
		public var offsetX:Number = 0;
		public var offsetY:Number = 0;
		
		public function Projection3D(){}
		
		final public function setDepthCliping(zNear:Number, zFar:Number):void
		{
			_zNear = zNear;
			_zFar = zFar;
			transform[2] = 1.0 / (zFar - zNear);
			transform[6] = transform[2] * -zNear;
		}
		
		final public function upload(context3d:GpuContext):void
		{
			transform[0] = scaleX;
			transform[1] = scaleY;
			transform[4] = offsetX;
			transform[5] = offsetY;
			context3d.setVc(0, transform, 2);
		}
		
		virtual public function getViewRay(screenX:Number, screenY:Number, ray:Ray):void{}
		virtual public function scene2screen(input:Vector3D, output:Vector3D):void{}
		virtual public function screen2scene(input:Vector3D, output:Vector3D):void{}
	}
}