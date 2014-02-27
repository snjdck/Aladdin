package snjdck.tesla.kernel.services.impl
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import flash.signals.ISignal;
	import flash.signals.Signal;
	import snjdck.tesla.kernel.services.IKeyboardService;
	import snjdck.tesla.kernel.services.support.Service;
	
	public class KeyboardService extends Service implements IKeyboardService
	{
		private const _keyDownSignal:Signal = new Signal(uint);
		private const _keyUpSignal:Signal = new Signal(uint);
		
		private const keyMap:Dictionary = new Dictionary();
		
		private var isAltKeyDown:Boolean;
		private var isCtrlKeyDown:Boolean;
		private var isShiftKeyDown:Boolean;
		
		public function KeyboardService()
		{
		}
		
		[Inject]
		public function onInit(stage:Stage):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN,	__onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,	__onKeyUp);
		}
		
		private function __onKeyDown(evt:KeyboardEvent):void
		{
			parse(evt, true);
			_keyDownSignal.notify(evt.keyCode);
		}
		
		private function __onKeyUp(evt:KeyboardEvent):void
		{
			parse(evt, false);
			_keyUpSignal.notify(evt.keyCode);
		}
		
		/**
		 * 
		 * @param evt
		 * @param flag 如果按键down,则为true,否则为false 
		 * 
		 */		
		private function parse(evt:KeyboardEvent, flag:Boolean):void
		{
			this.isAltKeyDown = evt.altKey;
			this.isCtrlKeyDown = evt.ctrlKey;
			this.isShiftKeyDown = evt.shiftKey;
			
			if(flag){
				keyMap[evt.keyCode] = null;
			}else{
				delete keyMap[evt.keyCode];
			}
		}
		
		public function get keyDownSignal():ISignal
		{
			return _keyDownSignal;
		}
		
		public function get keyUpSignal():ISignal
		{
			return _keyUpSignal;
		}
		
		
		public function get capsLock():Boolean 		{ return Keyboard.capsLock; }
		public function get numLock():Boolean 		{ return Keyboard.numLock; }
		public function get altKey():Boolean 		{ return isAltKeyDown; }
		public function get ctrlKey():Boolean 		{ return isCtrlKeyDown; }
		public function get shiftKey():Boolean 		{ return isShiftKeyDown; }
		
		public function isKeyDown(keyCode:uint):Boolean
		{
			return keyCode in keyMap;
		}
	}
}