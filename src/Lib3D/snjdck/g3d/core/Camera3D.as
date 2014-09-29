package snjdck.g3d.core
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import matrix44.transformCoords;
	import matrix44.transformCoordsDelta;
	import matrix44.transformVector;
	
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.geom.Ray;
	import snjdck.g3d.render.DrawUnitCollector3D;
	import snjdck.gpu.asset.GpuContext;
	
	import stdlib.constant.Unit;
	
	use namespace ns_g3d;

	public class Camera3D extends Object3D
	{
		public var viewFrustum:ViewFrustum;
		
		private const _worldMatrix:Matrix3D = new Matrix3D();
		private const _worldMatrixInvert:Matrix3D = new Matrix3D();
		
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
			_worldMatrixInvert.copyFrom(_worldMatrix);
			_worldMatrixInvert.invert();
		}
		
		public function uploadMatrix(context3d:GpuContext):void
		{
			context3d.setVcM(2, _worldMatrixInvert);
		}
		
		public function getSceneRay(screenX:Number, screenY:Number, ray:Ray):void
		{
			matrix44.transformCoords(_worldMatrix, screenX, screenY, 0, ray.pos);
			matrix44.transformCoordsDelta(_worldMatrix, 0, 0, 1, ray.dir);
		}
		
		/*
		public function followTarget(obj3d:Object3D):void
		{
			origin.x = obj3d.x;
			origin.y = obj3d.y;
			origin.z = obj3d.z;
		}
		*/
		/*
		public function moveCameraBy(dx:Number, dy:Number):void
		{
			moveCameraTo(camera.x + dx, camera.y + dy);
		}
		
		public function moveCameraTo(px:Number, py:Number):void
		{
			camera.x = px;
			camera.y = py;
			
			origin.x = py + px * 0.5;
			origin.y = py - px * 0.5;
		}
		
		public function moveOriginTo(px:Number, py:Number):void
		{
			origin.x = px;
			origin.y = py;
			
			camera.x = px - py;
			camera.y = (px + py) * 0.5;
		}
		
		override public function onUpdate(timeElapsed:int):void
		{
			super.onUpdate(timeElapsed);
			
			mvp.copyFrom(worldMatrix);
			mvp.appendTranslation(origin.x, origin.y, origin.z);
			mvp.invert();
			mvp.append(lens);
			
			viewFrustum.update(mvp);
		}
		
		override ns_g3d function getLocalRay(globalRay:Ray):Ray
		{
			return globalRay.transformToLocal(mvp);
		}
		
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