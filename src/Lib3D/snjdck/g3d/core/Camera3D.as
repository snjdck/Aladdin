package snjdck.g3d.core
{
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import matrix44.extractPosition;
	import matrix44.transformVector;
	import matrix44.transformVectorDelta;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.projection.OrthoProjection3D;
	import snjdck.g3d.projection.PerspectiveProjection3D;
	import snjdck.g3d.projection.Projection3D;
	import snjdck.g3d.render.DrawUnit3D;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.gpu.asset.GpuContext;
	
	import stdlib.constant.Unit;
	
	use namespace ns_g3d;

	public class Camera3D extends Object3D
	{
		static public function NewIsoCamera(screenWidth:int, screenHeight:int, zNear:Number, zFar:Number):Camera3D
		{
			var proj:OrthoProjection3D = new OrthoProjection3D();
			proj.resize(screenWidth, screenHeight);
			proj.setDepthCliping(zNear, zFar);
			
			var camera:Camera3D = new Camera3D();
			
			camera.rotationX = 120 * Unit.RADIAN;
			camera.rotationZ = -45 * Unit.RADIAN;
			camera.scale = Math.SQRT1_2;
			
			camera.projection = proj;
			
			return camera;
		}
		
		static public function NewPerspectiveCamera(fieldOfView:Number, aspectRatio:Number, zNear:Number, zFar:Number):Camera3D
		{
			var proj:PerspectiveProjection3D = new PerspectiveProjection3D();
			proj.fov(fieldOfView, aspectRatio);
			proj.setDepthCliping(zNear, zFar);
			
			var camera:Camera3D = new Camera3D();
			
			camera.rotationX = 135 * Unit.RADIAN;
			camera.rotationZ = -45 * Unit.RADIAN;
			
			camera.projection = proj;
			
			return camera;
		}
		
		static private const scissorRect:Rectangle = new Rectangle();
		public var viewFrustum:ViewFrustum;
		
		private const _worldMatrix:Matrix3D = new Matrix3D();
		private const _worldMatrixInvert:Matrix3D = new Matrix3D();
		
		public var projection:Projection3D;
		public const viewport:Viewport = new Viewport();
		public var clipViewport:Boolean = true;
		public var cullingMask:uint;
		public var depth:int;
		
		public var zOffset:Number = 0;
		
		public function Camera3D()
		{
			viewFrustum = new ViewFrustum();
		}
		
		override ns_g3d function collectDrawUnit(collector:DrawUnitCollector3D):void
		{
			collector.pushMatrix(transform);
			_worldMatrix.copyFrom(collector.worldMatrix);
			collector.popMatrix();
			
			collector.addCamera(this);
			
			_worldMatrix.prependTranslation(0, 0, zOffset);
			_worldMatrixInvert.copyFrom(_worldMatrix);
			_worldMatrixInvert.invert();
		}
		
		ns_g3d function drawBegin(context3d:GpuContext):void
		{
			projection.upload(context3d, viewport);
			context3d.setVcM(2, _worldMatrixInvert);
			
			scissorRect.x = viewport.x * context3d.bufferWidth;
			scissorRect.y = (1 - viewport.y - viewport.height) * context3d.bufferHeight;
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
			
			ray.worldMatrix.copyFrom(_worldMatrixInvert);
			
			matrix44.transformVector(_worldMatrix, ray.pos, ray.pos);
			matrix44.transformVectorDelta(_worldMatrix, ray.dir, ray.dir);
		}
		
		public function world2camera(input:Vector3D, output:Vector3D):void
		{
			matrix44.transformVector(_worldMatrixInvert, input, output);
		}
		
		public function world2screen(input:Vector3D, output:Vector3D):void
		{
			matrix44.transformVector(_worldMatrixInvert, input, output);
			projection.scene2screen(output, output);
		}
		
		public function sortDrawUnits(collector:DrawUnitCollector3D):void
		{
			collector.blendList.sort(__sortBlend);
			collector.opaqueList.sort(__sortOpaque);
		}
		
		private function __sortBlend(left:DrawUnit3D, right:DrawUnit3D):int
		{
			matrix44.extractPosition(left.worldMatrix, v1);
			matrix44.extractPosition(right.worldMatrix, v2);
			
			world2camera(v1, v1);
			world2camera(v2, v2);
			
			return v2.z - v1.z;
		}
		
		private function __sortOpaque(left:DrawUnit3D, right:DrawUnit3D):int
		{
			matrix44.extractPosition(left.worldMatrix, v1);
			matrix44.extractPosition(right.worldMatrix, v2);
			
			world2camera(v1, v1);
			world2camera(v2, v2);
			
			return v1.z - v2.z;
		}
		
		static private const v1:Vector3D = new Vector3D();
		static private const v2:Vector3D = new Vector3D();
	}
}