package snjdck.g2d.text.ime
{
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.FocusEvent;
	import flash.events.IMEEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.signals.Signal;
	import flash.text.ime.IIMEClient;
	import flash.ui.Keyboard;
	
	import snjdck.g2d.impl.Texture2D;
	import snjdck.g2d.obj2d.Image;
	import snjdck.gpu.asset.GpuAssetFactory;

	public class ImeMgr
	{
		static public const Instance:ImeMgr = new ImeMgr();
		
		private var imeClient:IIMEClient = new IMEClient();
		private var text:String = "";
		public var caretIndex:int = 0;
		private var stage:Stage;
		private var root:InteractiveObject;
		
		public const updateSignal:Signal = new Signal(String);
		
		public var caret:Image = new Image(new Texture2D(GpuAssetFactory.DefaultGpuTexture));
		public var isActive:Boolean;
		
		public function init(root:InteractiveObject):void
		{
			caret.width = 2;
			caret.height = 12;
			
			this.root = root;
			stage = root.stage;
			
			root.addEventListener(FocusEvent.FOCUS_IN, __onFocusIn);
			root.addEventListener(FocusEvent.FOCUS_OUT, __onFocusOut);
		}
		
		public function activeIME():void
		{
			stage.focus = root;
			isActive = true;
		}
		
		private function __onFocusIn(evt:FocusEvent):void
		{
			trace("focus in");
			root.addEventListener(IMEEvent.IME_START_COMPOSITION, __onIME);
			root.addEventListener(TextEvent.TEXT_INPUT, __onTextInput);
			root.addEventListener(KeyboardEvent.KEY_DOWN, __onKeyDown);
			root.addEventListener(KeyboardEvent.KEY_UP, __onKeyUp);
		}
		
		private function __onFocusOut(evt:FocusEvent):void
		{
			root.removeEventListener(IMEEvent.IME_START_COMPOSITION, __onIME);
			root.removeEventListener(TextEvent.TEXT_INPUT, __onTextInput);
			root.removeEventListener(KeyboardEvent.KEY_DOWN, __onKeyDown);
			root.removeEventListener(KeyboardEvent.KEY_UP, __onKeyUp);
			trace("focus out");
			updateSignal.delAll();
			caret.removeFromParent();
			isActive = false;
		}
		
		private function __onTextInput(evt:TextEvent):void
		{
			addChar(evt.text);
		}
		
		private function __onIME(evt:IMEEvent):void
		{
			evt.imeClient = imeClient;
		}
		
		private function __onKeyUp(evt:KeyboardEvent):void
		{
			
		}
		
		private function __onKeyDown(evt:KeyboardEvent):void
		{
			switch(evt.keyCode)
			{
				case Keyboard.BACKSPACE:
					removeChar();
					break;
				case Keyboard.LEFT:
					if(caretIndex > 0){
						--caretIndex;
					}
					break;
				case Keyboard.RIGHT:
					if(caretIndex < text.length){
						++caretIndex;
					}
					break;
			}
		}
		
		private function addChar(inputText:String):void
		{
			if(caretIndex <= 0){
				text = inputText + text;
			}else if(caretIndex >= text.length){
				text += inputText;
			}else{
				text = text.slice(0, caretIndex) + inputText + text.slice(caretIndex);
			}
			caretIndex += inputText.length;
			updateSignal.notify(text);
		}
		
		private function removeChar():void
		{
			if(caretIndex <= 0){
				return;
			}else if(caretIndex <= 1){
				text = text.slice(1);
			}else if(caretIndex >= text.length){
				text = text.slice(0, -1);
			}else{
				text = text.slice(0, caretIndex-1) + text.slice(caretIndex);
			}
			--caretIndex;
			updateSignal.notify(text);
		}
	}
}