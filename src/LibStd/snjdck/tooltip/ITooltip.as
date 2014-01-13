package snjdck.tooltip
{
	import snjdck.display.d2.IDisplayObject;
	
	public interface ITooltip extends IDisplayObject
	{
		function onInit():void;
		function setData(tipData:*):void;
	}
}