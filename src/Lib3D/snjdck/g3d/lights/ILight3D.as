package snjdck.g3d.lights
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import snjdck.g3d.rendersystem.RenderSystem;
	import snjdck.gpu.asset.GpuContext;

	public interface ILight3D
	{
		function drawShadowMap(context3d:GpuContext, render3d:RenderSystem, cameraPosition:Vector3D):void;
		function drawLight(context3d:GpuContext, cameraRotation:Matrix3D, cameraPosition:Vector3D):void;
	}
}