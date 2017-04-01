package snjdck.ui.scrollable
{
	import flash.display.DisplayObject;
	import flash.signals.ISignal;

	public interface IScrollAdapter
	{
		function get viewSizeX():Number;
		function get viewSizeY():Number;
		function get pageSizeX():Number;
		function get pageSizeY():Number;
		function get displayObject():DisplayObject;
		function updateViewX(value:Number):void;
		function updateViewY(value:Number):void;
		function updateViewW(value:Number):void;
		function updateViewH(value:Number):void;
		function get onPageSizeChanged():ISignal;
	}
}