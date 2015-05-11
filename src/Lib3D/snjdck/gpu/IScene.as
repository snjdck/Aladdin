package snjdck.gpu
{
	import snjdck.gpu.asset.GpuContext;

	public interface IScene
	{
		function update(timeElapsed:int):void;
		function preDrawDepth(context3d:GpuContext):void;
		function draw(context3d:GpuContext):void;
		function notifyEvent(evtType:String):Boolean;
		function get mouseX():Number;
		function get mouseY():Number;
	}
}