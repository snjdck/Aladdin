package snjdck.g3d.core
{
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	
	import matrix44.transformVector;
	import matrix44.transformVectorDelta;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.g3d.projection.Projection3D;
	
	import stdlib.constant.Unit;
	
	use namespace ns_g3d;

	public class Camera3D extends Object3D
	{
		static private const scissorRect:Rectangle = new Rectangle();
		public var viewFrustum:ViewFrustum;
		
		private const _worldMatrix:Matrix3D = new Matrix3D();
		private const _worldMatrixInvert:Matrix3D = new Matrix3D();
		
		public var projection:Projection3D;
		public const viewport:Viewport = new Viewport();
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
			
			scissorRect.x = viewport.x * context3d.bufferWidth;
			scissorRect.y = viewport.y * context3d.bufferHeight;
			scissorRect.width = viewport.width * context3d.bufferWidth;
			scissorRect.height = viewport.height * context3d.bufferHeight;
			
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
	}
}