package snjdck.g3d.core
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.geom.Ray;
	import snjdck.g3d.ns_g3d;
	
	use namespace ns_g3d;

	[Deprecated]
	internal class Camera3D extends Object3D
	{
		private var origin:Vector3D;
		
		private var mvp:Matrix3D;
		public var lens:Matrix3D;
		
		public var viewFrustum:ViewFrustum;
		
		public function Camera3D()
		{
			/** 等角投影矩阵 */
			localMatrix.appendScale(Math.SQRT2, Math.SQRT2, Math.SQRT2);
			localMatrix.appendRotation(45, new Vector3D(0, 0, 1));//绕z轴逆时针旋转45度
			localMatrix.appendRotation(-120, new Vector3D(1, 0, 0));//绕x轴顺时针旋转120度
			localMatrix.invert();
			
			origin = new Vector3D();
//			camera = new Vector3D();
			
			mvp = new Matrix3D();
			
			viewFrustum = new ViewFrustum();
		}
		
		public function setLens(val:Matrix3D):void
		{
			this.lens = val;
		}
		
		public function getMvpMatrix():Matrix3D
		{
			return mvp;
		}
		
		public function moveOriginTo(pos:Vector3D):void
		{
			origin.copyFrom(pos);
		}
		
		public function followTarget(obj3d:Object3D):void
		{
			origin.x = obj3d.x;
			origin.y = obj3d.y;
			origin.z = obj3d.z;
		}
		
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