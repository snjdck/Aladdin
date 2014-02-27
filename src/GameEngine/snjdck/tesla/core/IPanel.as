package snjdck.tesla.core
{
	import flash.display.DisplayObject;
	
	import flash.signals.ISignal;

	public interface IPanel
	{
		function get autoArrange():Boolean;
		function get showPolicy():String;
		function get isModal():Boolean;
		
		function isShowing():Boolean;
		function show():void;
		function hide():void;
		
		function get showSignal():ISignal;
		function get hideSignal():ISignal;
		
		function getDisplayObject():DisplayObject;
	}
}