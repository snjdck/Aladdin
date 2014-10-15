package snjdck.g3d.render
{
	import flash.display3D.Context3DCompareMode;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import matrix44.extractAxixsZ;
	import matrix44.extractPosition;
	import matrix44.transformVector;
	import matrix44.transformVectorDelta;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.core.ViewFrustum;
	import snjdck.g3d.core.Viewport;
	import snjdck.g3d.pickup.Ray;
	import snjdck.g3d.projection.Projection3D;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g3d;

	public class CameraUnit3D
	{
		static private const scissorRect:Rectangle = new Rectangle();
		
		private const _worldMatrix:Matrix3D = new Matrix3D();
		private const _worldMatrixInvert:Matrix3D = new Matrix3D();
		
		public var projection:Projection3D;
		public var viewport:Viewport;
		public var depth:int;
		public var mouseEnabled:Boolean;
		public var clipViewport:Boolean = true;
		
		public var viewFrustum:ViewFrustum = new ViewFrustum();
		private var _forward:Vector3D = new Vector3D();
		
		public function CameraUnit3D()
		{
		}
		
		public function get forward():Vector3D
		{
			extractAxixsZ(_worldMatrix, _forward);
			return _forward;
		}
		
		public function copyFrom(other:CameraUnit3D):void
		{
			_worldMatrix.copyFrom(other._worldMatrix);
			_worldMatrixInvert.copyFrom(other._worldMatrixInvert);
			
			projection = other.projection;
			viewport.copyFrom(other.viewport);
			
			depth = other.depth;
			mouseEnabled = other.mouseEnabled;
			clipViewport = other.clipViewport;
		}
		
		public function appendMatrix(other:Matrix3D):void
		{
			_worldMatrix.append(other);
			_worldMatrixInvert.copyFrom(_worldMatrix);
			_worldMatrixInvert.invert();
		}
		
		public function reset(camera:Camera3D, worldMatrix:Matrix3D, zOffset:Number):void
		{
			projection = camera.projection;
			viewport = camera.viewport;
			depth = camera.depth;
			mouseEnabled = camera.mouseEnabled;
			clipViewport = camera.clipViewport;
			
			_worldMatrix.copyFrom(worldMatrix);
			_worldMatrix.prependTranslation(0, 0, zOffset);
			_worldMatrixInvert.copyFrom(_worldMatrix);
			_worldMatrixInvert.invert();
		}
		
		public function render(render3d:Render3D, collector:DrawUnitCollector3D, context3d:GpuContext):void
		{
			drawBegin(context3d);
			sortDrawUnits(collector);
			
			var drawUnit:IDrawUnit3D;
			
			if(collector.opaqueList.length > 0){
				context3d.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
				for each(drawUnit in collector.opaqueList){
					//todo judge whether the object is in camera's sight
					drawUnit.draw(render3d, this, collector, context3d);
				}
			}
			
			if(collector.blendList.length > 0){
				context3d.setDepthTest(false, Context3DCompareMode.LESS_EQUAL);
				for each(drawUnit in collector.blendList){
					//todo judge whether the object is in camera's sight
					drawUnit.draw(render3d, this, collector, context3d);
				}
			}
			
			drawEnd(context3d);
		}
		
		ns_g3d function drawBegin(context3d:GpuContext):void
		{
			projection.upload(context3d, viewport);
			context3d.setVcM(2, _worldMatrixInvert);
			
			if(clipViewport){
				scissorRect.x = viewport.x * context3d.bufferWidth;
				scissorRect.y = (1 - viewport.y - viewport.height) * context3d.bufferHeight;
				scissorRect.width = viewport.width * context3d.bufferWidth;
				scissorRect.height = viewport.height * context3d.bufferHeight;
				context3d.setScissorRect(scissorRect);
			}
		}
		
		private function drawEnd(context3d:GpuContext):void
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
		
		private function sortDrawUnits(collector:DrawUnitCollector3D):void
		{
//			collector.blendList.sort(__sortBlend);
//			collector.opaqueList.sort(__sortOpaque);
		}
		/*
		private function __sortBlend(left:IDrawUnit3D, right:IDrawUnit3D):int
		{
			if(!(left is DrawUnit3D && right is DrawUnit3D)){
				return 0;
			}
			
			matrix44.extractPosition(left.worldMatrix, v1);
			matrix44.extractPosition(right.worldMatrix, v2);
			
			world2camera(v1, v1);
			world2camera(v2, v2);
			
			return v2.z - v1.z;
		}
		
		private function __sortOpaque(left:IDrawUnit3D, right:IDrawUnit3D):int
		{
			if(!(left is DrawUnit3D && right is DrawUnit3D)){
				return 0;
			}
			
			matrix44.extractPosition(left.worldMatrix, v1);
			matrix44.extractPosition(right.worldMatrix, v2);
			
			world2camera(v1, v1);
			world2camera(v2, v2);
			
			return v1.z - v2.z;
		}
		*/
		static private const v1:Vector3D = new Vector3D();
		static private const v2:Vector3D = new Vector3D();
	}
}