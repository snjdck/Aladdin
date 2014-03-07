package ui.scrollpane
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ui.Slider;
	
	[Event(name="scroll", type="flash.events.Event")]
	
	public class ScrollBar extends Sprite
	{
		private var _upArrowUI:DisplayObject;
		private var _downArrowUI:DisplayObject;
		private var _slider:Slider;
		
		public function ScrollBar()
		{
			_slider = new Slider();
			addChild(_slider);
			
			addEventListener(MouseEvent.MOUSE_DOWN, __onTrackMouseDown);
			height = 100;
		}
		
		public function get slider():Slider
		{
			return _slider;
		}
		
		public function get upArrowUI():DisplayObject
		{
			return _upArrowUI;
		}
		
		public function set upArrowUI(value:DisplayObject):void
		{
			if(null == value){
				throw new Error("value can't be null!");
			}
			if(upArrowUI == value){
				return;
			}
			if(upArrowUI){
				removeChild(upArrowUI);
			}
			_upArrowUI = value;
			addChild(upArrowUI);
			
			_slider.y = _upArrowUI.height;
			if(null != downArrowUI){
				_slider.height = downArrowUI.y - _slider.y;
			}
		}
		
		public function get downArrowUI():DisplayObject
		{
			return _downArrowUI;
		}
		
		public function set downArrowUI(value:DisplayObject):void
		{
			if(null == value){
				throw new Error("value can't be null!");
			}
			if(downArrowUI == value){
				return;
			}
			if(downArrowUI){
				removeChild(downArrowUI);
			}
			_downArrowUI = value;
			addChild(downArrowUI);
			
			downArrowUI.y = this.height - downArrowUI.height;
			_slider.height = downArrowUI.y - _slider.y;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			_slider.height = value - (upArrowUI.height + downArrowUI.height);
			downArrowUI.y = value - downArrowUI.height;
		}
		
		public var arrowStepSize:Number = 1;
		private var scrollStepSize:Number;
		
		private function __onTrackMouseDown(event:MouseEvent):void
		{
			if(upArrowUI.hitTestPoint(event.stageX, event.stageY)){
				scrollStepSize = -arrowStepSize;
			}else if(downArrowUI.hitTestPoint(event.stageX, event.stageY)){
				scrollStepSize = arrowStepSize;
			}else{
				return;
			}
			
			_slider.scroll(scrollStepSize);
		}
		
		public function set trackStepSize(value:Number):void
		{
			slider.trackStepSize = value;
		}
		
		public function get pageSize():Number
		{
			return slider.pageSize;
		}
		
		public function set pageSize(value:Number):void
		{
			slider.pageSize = value;
		}
		
		public function get viewSize():Number
		{
			return slider.viewSize;
		}
		
		public function set viewSize(value:Number):void
		{
			slider.viewSize = value;
		}
		
		public function canScroll():Boolean
		{
			return slider.canScroll();
		}
		
		public function scroll(stepSize:Number):void
		{
			slider.scroll(stepSize);
		}
		
		public function get scrollV():Number
		{
			return slider.scrollV;
		}
		
		public function set scrollV(value:Number):void
		{
			slider.scrollV = value;
		}
	}
}