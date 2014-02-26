package snjdck.tooltip
{
	import flash.display.IDisplayObject;
	
	public interface ITooltip extends IDisplayObject
	{
		function onInit():void;
		function setData(tipData:*):void;
	}
}