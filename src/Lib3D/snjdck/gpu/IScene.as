package snjdck.gpu
{
	import snjdck.gpu.asset.GpuContext;

	public interface IScene
	{
		function update(timeElapsed:int):void;
		function preDrawDepth(context3d:GpuContext):void;
		function needDraw():Boolean;
		function draw(context3d:GpuContext):void;
		function notifyEvent(evtType:String):Boolean;
		function get mouseX():Number;
		function get mouseY():Number;
		
		function resize(width:int, height:int):void;
		function get stageWidth():int;
		function get stageHeight():int;
	}
}