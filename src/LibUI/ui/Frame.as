package ui
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ui.button.Button;
	import ui.core.Component;
	import ui.support.DefaultConfig;
	import ui.text.Label;
	
	[Event(name="close", type="flash.events.Event")]
	
	public class Frame extends Component
	{
		private var titleLabel:Label;
		private var _closeBtn:Button;
		
		public function Frame()
		{
			super();
			titleLabel.addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
		}
		
		public function close():void
		{
			this.visible = false;
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function __onClose(event:MouseEvent):void
		{
			close();
		}
		
		private function __onMouseDown(event:MouseEvent):void
		{
			titleLabel.addEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
			startDrag();
		}
		
		private function __onMouseUp(event:MouseEvent):void
		{
			titleLabel.removeEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
			stopDrag();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			titleLabel = new Label();
			closeBtn = DefaultConfig.createCloseBtn();
			
			$_addChild(titleLabel);
		}
		
		override protected function initDefaultUI():void
		{
			super.initDefaultUI();
			
			contentX = 10;
			contentY = 40;
			
			backgroundChild = DefaultConfig.createFrameBg();
			
			titleLabel.x = 200;
			closeBtn.x = 660;
			closeBtn.y = 8;
		}
		
		public function get title():String
		{
			return titleLabel.text;
		}

		public function set title(value:String):void
		{
			titleLabel.text = value;
			titleLabel.backgroundColor = 0x00FFFFFF;
		}
		
		public function set closable(value:Boolean):void
		{
			
		}

		public function get closeBtn():Button
		{
			return _closeBtn;
		}

		public function set closeBtn(value:Button):void
		{
			if(closeBtn == value){
				return;
			}
			if(closeBtn){
				closeBtn.removeEventListener(MouseEvent.CLICK, __onClose);
				$_removeChild(closeBtn);
			}
			_closeBtn = value;
			if(closeBtn){
				closeBtn.addEventListener(MouseEvent.CLICK, __onClose);
				$_addChild(closeBtn);
			}
		}

	}
}