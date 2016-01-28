package snjdck.g3d.render
{
	import snjdck.g3d.core.Object3D;
	import snjdck.g3d.pickup.Ray;
	import snjdck.gpu.BlendMode;
	import snjdck.gpu.asset.GpuContext;

	public interface IDrawUnit3D
	{
		/** camera3d用于billboard修正方向和判断subMesh可见性  */
		function draw(context3d:GpuContext):void;
		
		function get shaderName():String;
		function get blendMode():BlendMode;
		function hitTest(worldRay:Ray, result:Vector.<Object3D>):void;
	}
}