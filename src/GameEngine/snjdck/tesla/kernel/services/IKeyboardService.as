package snjdck.tesla.kernel.services
{
	import flash.signals.ISignal;

	public interface IKeyboardService
	{
		function get keyDownSignal():ISignal;
		function get keyUpSignal():ISignal;
		
		function get capsLock():Boolean;
		function get numLock():Boolean;
		function get altKey():Boolean;
		function get ctrlKey():Boolean;
		function get shiftKey():Boolean;
		
		function isKeyDown(keyCode:uint):Boolean;
	}
}