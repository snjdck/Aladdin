package snjdck.g3d.render
{
	import snjdck.g3d.core.Camera3D;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;

	public interface IDrawUnit3D
	{
		function isInSight(camera3d:Camera3D):Boolean;
		function draw(context3d:GpuContext, camera3d:Camera3D):void;
		
		function get shaderName():String;
		function get blendMode():BlendMode;
	}
}