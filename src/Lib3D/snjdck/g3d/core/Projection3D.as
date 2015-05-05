package snjdck.g3d.core
{
	import flash.geom.Matrix;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.pickup.Ray;
	import snjdck.gpu.asset.GpuContext;
	
	/**
	 * 平行投影,left hand
	 */
	internal class Projection3D
	{
		private const transform:Vector.<Number> = new Vector.<Number>(8, true);
		
		private var scaleX:Number;
		private var scaleY:Number;
		
		private var _zNear:Number;
		
		public var viewFrustum:ViewFrustum;
		private var offsetX:Number = 0;
		private var offsetY:Number = 0;
		
		public function Projection3D()
		{
		}
		
		public function resize(width:int, height:int):void
		{
			scaleX = 2 / width;
			scaleY = 2 / height;
		}
		
		final public function setDepthCliping(zNear:Number, zFar:Number):void
		{
			_zNear = zNear;
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
		
		public function setViewport(worldMatrix:Matrix, width:int, height:int):void
		{
			offsetX = (worldMatrix.tx + width * 0.5) * scaleX - 1;
			offsetY = 1 - (worldMatrix.ty + height * 0.5) * scaleY;
		}
		
		public function resetViewport():void
		{
			offsetX = offsetY = 0;
		}
		
		public function getViewRay(screenX:Number, screenY:Number, ray:Ray):void
		{
			var viewX:Number = (screenX - transform[4]) / transform[0];
			var viewY:Number = (screenY - transform[5]) / transform[1];
			
			ray.pos.setTo(viewX, viewY, _zNear);
			ray.dir.setTo(0, 0, 1);
		}
		
		public function scene2screen(input:Vector3D, output:Vector3D):void
		{
			output.x = input.x * transform[0] + transform[4];
			output.y = input.y * transform[1] + transform[5];
			output.z = input.z * transform[2] + transform[6];
		}
		
		public function screen2scene(input:Vector3D, output:Vector3D):void
		{
			output.x = (input.x - transform[4]) / transform[0];
			output.y = (input.y - transform[5]) / transform[1];
			output.z = (input.z - transform[6]) / transform[2];
		}
	}
}