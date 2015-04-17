package snjdck.g3d.support
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.projection.OrthoProjection3D;
	import snjdck.g3d.projection.PerspectiveProjection3D;
	import snjdck.g3d.viewfrustum.OrthoViewFrustum;
	import snjdck.g3d.viewfrustum.PerspectiveViewFrustum;
	
	import stdlib.constant.Unit;

	final public class Camera3DFactory
	{
		static public function NewIsoCamera(screenWidth:int, screenHeight:int, zNear:Number, zFar:Number):Camera3D
		{
			var proj:OrthoProjection3D = new OrthoProjection3D();
			proj.setDepthCliping(zNear, zFar);
			proj.resize(screenWidth, screenHeight);
			
			var camera:Camera3D = new Camera3D();
			
//			camera.rotationX = 120 * Unit.RADIAN;
//			camera.rotationZ = -45 * Unit.RADIAN;
			var matrix:Matrix3D = camera.localMatrix;
			matrix.appendRotation(120, Vector3D.X_AXIS);
			matrix.appendRotation(-45, Vector3D.Z_AXIS);
			
			camera.projection = proj;
			camera.viewFrusum = new OrthoViewFrustum(screenWidth, screenHeight, zNear, zFar);
			
			return camera;
		}
		
		static public function NewPerspectiveCamera(fieldOfView:Number, aspectRatio:Number, zNear:Number, zFar:Number):Camera3D
		{
			var proj:PerspectiveProjection3D = new PerspectiveProjection3D();
			proj.setDepthCliping(zNear, zFar);
			proj.fov(fieldOfView, aspectRatio);
			
			var camera:Camera3D = new Camera3D();
			
			var matrix:Matrix3D = camera.localMatrix;
			matrix.appendRotation(135, Vector3D.X_AXIS);
			matrix.appendRotation(-45, Vector3D.Z_AXIS);
//			camera.rotationX = 135 * Unit.RADIAN;
//			camera.rotationZ = -45 * Unit.RADIAN;
			
			camera.projection = proj;
			camera.viewFrusum = new PerspectiveViewFrustum(fieldOfView, aspectRatio, zNear, zFar);
			
			return camera;
		}
	}
}