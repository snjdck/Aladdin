package snjdck.g3d.cameras
{
	import snjdck.g3d.lights.ILight3D;
	import snjdck.gpu.asset.GpuContext;
	import snjdck.g3d.renderer.IDrawUnitCollector3D;

	public interface ICamera3D extends IDrawUnitCollector3D
	{
		function setScreenSize(width:int, height:int):void;
		function get depth():int;
		
		function clear():void;
		function draw(context3d:GpuContext):void;
		
		function getLightCount():int;
		function getLightAt(index:int):ILight3D;
	}
}