package snjdck.g2d.text.ime
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IMEEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.ui.Keyboard;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.obj2d.Image;
	import snjdck.g2d.text.TextInput;
	
	use namespace ns_g2d;

	public class ImeMgr
	{
		static public const Instance:ImeMgr = new ImeMgr();
		
		private var textInput:TextInput;
		private var root:InteractiveObject;
		
		public const caret:Image = new Caret();
		
		private var caretTimerId:uint;
		private var prevFocus:TextInput;
		
		public function init(root:InteractiveObject):void
		{
			this.root = root;
			root.stage.stageFocusRect = false;
		}
		
		public function activeIME(textInput:TextInput):void
		{
			this.textInput = textInput;
			root.stage.focus = root;
			__onFocusIn();
		}
		
		public function isFocus(textInput:TextInput):Boolean
		{
			return this.textInput == textInput;
		}
		
		private function updateCaret():void
		{
			caret.visible = !caret.visible;
		}
		
		private function __onFocusIn():void
		{
			caretTimerId = setInterval(updateCaret, 500);
			trace("focus in");
			root.addEventListener(IMEEvent.IME_START_COMPOSITION, __onIME);
			root.addEventListener(TextEvent.TEXT_INPUT, __onTextInput);
			root.addEventListener(KeyboardEvent.KEY_DOWN, __onKeyDown);
			root.addEventListener(FocusEvent.FOCUS_OUT, __onFocusOut);
			root.addEventListener(Event.DEACTIVATE, __onDeactive);
		}
		
		private function __onDeactive(evt:Event):void
		{
			root.addEventListener(Event.ACTIVATE, __onActive);
			trace("de active");
			prevFocus = textInput;
		}
		
		private function __onActive(evt:Event):void
		{
			root.removeEventListener(Event.ACTIVATE, __onActive);
			trace("active");
			activeIME(prevFocus);
			prevFocus = null;
		}
		
		private function __onFocusOut(evt:FocusEvent):void
		{
			root.removeEventListener(Event.DEACTIVATE, __onDeactive);
			root.removeEventListener(FocusEvent.FOCUS_OUT, __onFocusOut);
			root.removeEventListener(IMEEvent.IME_START_COMPOSITION, __onIME);
			root.removeEventListener(TextEvent.TEXT_INPUT, __onTextInput);
			root.removeEventListener(KeyboardEvent.KEY_DOWN, __onKeyDown);
			trace("focus out");
			clearInterval(caretTimerId);
			textInput = null;
		}
		
		private function __onTextInput(evt:TextEvent):void
		{
			textInput.addChar(evt.text);
		}
		
		private function __onIME(evt:IMEEvent):void
		{
			evt.imeClient = textInput.imeClient;
		}
		
		private function __onKeyDown(evt:KeyboardEvent):void
		{
			switch(evt.keyCode)
			{
				case Keyboard.BACKSPACE:
					textInput.removeChar();
					break;
				case Keyboard.LEFT:
					textInput.moveCaretLeft();
					break;
				case Keyboard.RIGHT:
					textInput.moveCaretRight();
					break;
				case Keyboard.UP:
					textInput.moveCaretUp();
					break;
				case Keyboard.DOWN:
					textInput.moveCaretDown();
					break;
				case Keyboard.HOME:
					textInput.moveCaretToBegin();
					break;
				case Keyboard.END:
					textInput.moveCaretToEnd();
					break;
			}
		}
	}
}