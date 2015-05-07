package snjdck.g3d.render
{
	import snjdck.g3d.core.Camera3D;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;

	public interface IDrawUnit3D
	{
		/** camera3d用于billboard修正方向和判断subMesh可见性  */
		function draw(context3d:GpuContext, camera3d:Camera3D):void;
		
		function get shaderName():String;
		function get blendMode():BlendMode;
	}
}