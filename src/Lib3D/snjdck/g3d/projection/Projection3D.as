package snjdck.g3d.projection
{
	import flash.geom.Vector3D;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.ViewFrustum;
	import snjdck.g3d.core.Viewport;
	import snjdck.g3d.pickup.Ray;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g3d;

	public class Projection3D
	{
		protected const transform:Vector.<Number> = new Vector.<Number>(8, true);
		
		protected var scaleX:Number;
		protected var scaleY:Number;
		
		protected var _zNear:Number;
		
		public const viewFrustum:ViewFrustum = new ViewFrustum();
		
		public function Projection3D(){}
		
		final public function setDepthCliping(zNear:Number, zFar:Number):void
		{
			_zNear = zNear;
			transform[2] = 1.0 / (zFar - zNear);
			transform[6] = transform[2] * -zNear;
			
			viewFrustum.near.w = -zNear;
			viewFrustum.far.w = zFar;
		}
		
		final public function upload(context3d:GpuContext, viewport:Viewport):void
		{
			viewport.adjust(transform, scaleX, scaleY);
			context3d.setVc(0, transform, 2);
		}
		
		virtual public function getViewRay(screenX:Number, screenY:Number, ray:Ray):void{}
		virtual public function scene2screen(input:Vector3D, output:Vector3D):void{}
		virtual public function screen2scene(input:Vector3D, output:Vector3D):void{}
	}
}