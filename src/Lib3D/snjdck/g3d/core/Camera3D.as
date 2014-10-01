package snjdck.g3d.core
{
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	
	import matrix44.transformCoords;
	import matrix44.transformCoordsDelta;
	import matrix44.transformVector;
	import matrix44.transformVectorDelta;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.gpu.projection.Projection3D;
	
	import stdlib.constant.Unit;
	
	use namespace ns_g3d;

	public class Camera3D extends Object3D
	{
		static private const scissorRect:Rectangle = new Rectangle();
		public var viewFrustum:ViewFrustum;
		
		private const _worldMatrix:Matrix3D = new Matrix3D();
		private const _worldMatrixInvert:Matrix3D = new Matrix3D();
		
		public var projection:Projection3D;
		public const viewportRect:Rectangle = new Rectangle(0, 0, 1, 1);
		public var clipViewport:Boolean = true;
		public var cullingMask:uint;
		public var depth:int;
		
		public function Camera3D()
		{
			rotationX = 120 * Unit.RADIAN;
			rotationZ = -45 * Unit.RADIAN;
			scale = Math.SQRT1_2;
			
			_worldMatrix.copyFrom(transform);
			_worldMatrixInvert.copyFrom(_worldMatrix);
			_worldMatrixInvert.invert();
			
			viewFrustum = new ViewFrustum();
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			collector.pushMatrix(transform);
			_worldMatrix.copyFrom(collector.worldMatrix);
			collector.popMatrix();
			
			collector.addCamera(this);
			
			_worldMatrixInvert.copyFrom(_worldMatrix);
			_worldMatrixInvert.invert();
		}
		
		ns_g3d function drawBegin(context3d:GpuContext):void
		{
			projection.upload(context3d, this);
			context3d.setVcM(2, _worldMatrixInvert);
			
			scissorRect.x = viewportRect.x * context3d.bufferWidth;
			scissorRect.y = viewportRect.y * context3d.bufferHeight;
			scissorRect.width = viewportRect.width * context3d.bufferWidth;
			scissorRect.height = viewportRect.height * context3d.bufferHeight;
			
			if(clipViewport){
				context3d.setScissorRect(scissorRect);
			}
		}
		
		ns_g3d function drawEnd(context3d:GpuContext):void
		{
			if(clipViewport){
				context3d.setScissorRect(null);
			}
		}
		
		/**
		 * @param screenX [-1, 1]
		 * @param screenY [-1, 1]
		 */		
		public function getSceneRay(screenX:Number, screenY:Number, ray:Ray):void
		{
			projection.getViewRay(screenX, screenY, ray);
			
			matrix44.transformVector(_worldMatrix, ray.pos, ray.pos);
			matrix44.transformVectorDelta(_worldMatrix, ray.dir, ray.dir);
		}
		
		/*
		static private const CONST_A:Number = 0.5 * Math.sqrt(6);
		static private const CONST_B:Number = 0.5 * Math.sqrt(3);
		
		public function isoToScreen(isoPt:Vector3D, screenPt:Vector3D):void
		{
			screenPt.x = isoPt.x - isoPt.y;
			screenPt.y = (isoPt.x + isoPt.y) * 0.5 - isoPt.z * CONST_A;
			screenPt.z = (isoPt.x + isoPt.y) * CONST_B + isoPt.z * Math.SQRT1_2;
			
			screenPt.x -= camera.x;
			screenPt.y -= camera.y;
		}
		
		public function screenToIso(screenPt:Vector3D, isoPt:Vector3D):void
		{
			var screenX:Number = camera.x + screenPt.x;
			var screenY:Number = camera.y + screenPt.y;
			
			isoPt.x = screenY + screenX * 0.5;
			isoPt.y = screenY - screenX * 0.5;
		}
		//*/
	}
}