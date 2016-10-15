package snjdck.g3d.lights
{
	import flash.geom.Matrix3D;
	
	import snjdck.g3d.rendersystem.RenderSystem;
	import snjdck.gpu.asset.GpuContext;

	public interface ILight3D
	{
		function drawShadowMap(context3d:GpuContext, render3d:RenderSystem):void;
		function drawLight(context3d:GpuContext, cameraTransform:Matrix3D):void;
	}
}