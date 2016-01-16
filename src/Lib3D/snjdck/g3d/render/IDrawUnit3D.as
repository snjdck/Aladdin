package snjdck.g3d.render
{
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;

	public interface IDrawUnit3D
	{
		/** camera3d用于billboard修正方向和判断subMesh可见性  */
		function draw(context3d:GpuContext):void;
		
		function get shaderName():String;
		function get blendMode():BlendMode;
	}
}