package snjdck.gpu.render
{
	public interface IRender
	{
		function pushScreen(width:int, height:int, offsetX:Number=0, offsetY:Number=0):void;
		function popScreen():void;
	}
}