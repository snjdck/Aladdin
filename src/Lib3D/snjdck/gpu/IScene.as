package snjdck.gpu
{
	import snjdck.gpu.asset.GpuContext;

	public interface IScene
	{
		function update(timeElapsed:int):void;
		function draw(context3d:GpuContext):void;
	}
}