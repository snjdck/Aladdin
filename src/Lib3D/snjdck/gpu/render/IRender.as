package snjdck.gpu.render
{
	public interface IRender
	{
		function pushScreen(width:int, height:int):void;
		function popScreen():void;
	}
}