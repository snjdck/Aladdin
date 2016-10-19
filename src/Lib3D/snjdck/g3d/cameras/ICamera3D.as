package snjdck.g3d.cameras
{
	import snjdck.g3d.lights.ILight3D;
	import snjdck.gpu.asset.GpuContext;

	public interface ICamera3D extends IDrawUnitCollector3D
	{
		function setScreenSize(width:int, height:int):void;
		
		function clear():void;
		function draw(context3d:GpuContext):void;
		
		function getLightCount():int;
		function getLightAt(index:int):ILight3D;
	}
}