package snjdck.g3d.support
{
	import snjdck.g3d.core.Camera3D;
	import snjdck.g3d.projection.OrthoProjection3D;
	import snjdck.g3d.projection.PerspectiveProjection3D;
	import snjdck.g3d.viewfrustum.OrthoViewFrustum;
	
	import stdlib.constant.Unit;

	final public class Camera3DFactory
	{
		static public function NewIsoCamera(screenWidth:int, screenHeight:int, zNear:Number, zFar:Number):Camera3D
		{
			var proj:OrthoProjection3D = new OrthoProjection3D();
			proj.resize(screenWidth, screenHeight);
			proj.setDepthCliping(zNear, zFar);
			
			var camera:Camera3D = new Camera3D();
			
			camera.rotationX = 120 * Unit.RADIAN;
			camera.rotationZ = -45 * Unit.RADIAN;
//			camera.scale = Math.SQRT1_2;
			
			camera.projection = proj;
			camera.viewFrusum = new OrthoViewFrustum(screenWidth, screenHeight, zNear, zFar);
			
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
	}
}