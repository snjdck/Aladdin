package ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.support.StepTimer;
	
	[Event(name="scroll", type="flash.events.Event")]
	
	public class Slider extends Sprite
	{
		private var _thumbBtn:DisplayObject;
		private var _trackUI:DisplayObject;
		
		private var delayTimer:StepTimer;
		
		private var _viewSize:Number = 0;
		private var _pageSize:Number = 1;
		
		private var _scrollV:Number = 0;
		
		public var minValue:Number = 0;
		public var maxValue:Number = 1;
		
		private var _type:String = "v";
		
		public function Slider()
		{
			delayTimer = new StepTimer(500, 50);
			delayTimer.addEventListener(TimerEvent.TIMER, __onTimerTrigged);
			
			super.height = 100;
			
			addEventListener(MouseEvent.MOUSE_DOWN, __onTrackMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, __onTrackMouseUp);
			addEventListener(MouseEvent.ROLL_OUT, __onTrackMouseUp);
		}
		
		public function get thumbBtn():DisplayObject
		{
			return _thumbBtn;
		}
		
		public function set thumbBtn(value:DisplayObject):void
		{
			if(null == value){
				throw new Error("value can't be null!");
			}
			if(thumbBtn == value){
				return;
			}
			if(thumbBtn){
				thumbBtn.removeEventListener(MouseEvent.MOUSE_DOWN, __onThumbEvent);
				removeChild(thumbBtn);
			}
			
			_thumbBtn = value;
			
			thumbBtn.addEventListener(MouseEvent.MOUSE_DOWN, __onThumbEvent);
			addChild(thumbBtn);
		}
		
		public function get trackUI():DisplayObject
		{
			return _trackUI;
		}
		
		public function set trackUI(value:DisplayObject):void
		{
			if(null == value){
				throw new Error("value can't be null!");
			}
			if(trackUI == value){
				return;
			}
			if(trackUI){
				removeChild(trackUI);
			}
			_trackUI = value;
			
			trackUI.height = this.height;
			addChild(trackUI);
		}
		
		public function get scrollV():Number
		{
			return _scrollV;
		}
		
		public function get thumbSize():Number
		{
			return (viewSize / pageSize) * height;
		}
		
		public function get maxThumbLocation():Number
		{
			return height - thumbSize;
		}
		
		public function set scrollV(value:Number):void
		{
			_scrollV = (value > 1) ? 1 : (value < 0 ? 0 : value);
			thumbBtn.y = scrollV * maxThumbLocation;
			dispatchEvent(new Event(Event.SCROLL, true));
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			trackUI.height = value;
			updateThumbHeight(calcPageViewSizeDiff());
		}
		
		private function updateThumbHeight(prevPageViewDiff:Number):void
		{
			if(canScroll()){
				scrollV *= prevPageViewDiff / calcPageViewSizeDiff();
				thumbBtn.height = thumbSize;
				thumbBtn.visible = true;
			}else{
				scrollV = 0;
				thumbBtn.visible = false;
			}
		}
		
		public var trackStepSize:Number = 2;
		private var scrollStepSize:Number;
		
		private function __onTrackMouseDown(event:MouseEvent):void
		{
			if(thumbBtn.hitTestPoint(event.stageX, event.stageY)){
				return;
			}
			
			scrollStepSize = trackStepSize * (mouseY < thumbBtn.y ? -1 : 1);
			
			scroll(scrollStepSize);
			delayTimer.start();
		}
		
		private function __onTrackMouseUp(event:MouseEvent):void
		{
			delayTimer.stop();
		}
		
		private function __onTimerTrigged(event:Event):void
		{
			if(thumbBtn.hitTestPoint(stage.mouseX, stage.mouseY)){
				delayTimer.stop();
			}else{
				scroll(scrollStepSize);
			}
		}
		
		public function scroll(stepSize:Number):void
		{
			if(canScroll()){
				scrollV += stepSize / calcPageViewSizeDiff();
			}
		}
		
		private var dragThumbY:Number;
		private var dragMouseX:Number;
		private var dragMouseY:Number;
		
		private function __onThumbEvent(event:MouseEvent):void
		{
			switch(event.type)
			{
				case MouseEvent.MOUSE_MOVE:
					var distance:Number = ("vertical" == type) ? (event.stageY - dragMouseY) : (event.stageX - dragMouseX);
					scrollV = dragThumbY + distance / maxThumbLocation;
					break;
				case MouseEvent.MOUSE_DOWN:
					dragThumbY = scrollV;
					dragMouseX = event.stageX;
					dragMouseY = event.stageY;
					stage.addEventListener(MouseEvent.MOUSE_MOVE, __onThumbEvent);
					stage.addEventListener(MouseEvent.MOUSE_UP, __onThumbEvent);
					break;
				case MouseEvent.MOUSE_UP:
					stage.removeEventListener(MouseEvent.MOUSE_MOVE, __onThumbEvent);
					stage.removeEventListener(MouseEvent.MOUSE_UP, __onThumbEvent);
					break;
			}
		}
		
		public function canScroll():Boolean
		{
			return pageSize > viewSize;
		}
		
		private function calcPageViewSizeDiff():Number
		{
			return pageSize - viewSize;
		}
		
		public function get viewSize():Number
		{
			return _viewSize;
		}
		
		public function set viewSize(value:Number):void
		{
			if(viewSize == value){
				return;
			}
			var prevPageViewDiff:Number = calcPageViewSizeDiff();
			_viewSize = value;
			updateThumbHeight(prevPageViewDiff);
		}
		
		public function get pageSize():Number
		{
			return _pageSize;
		}
		
		public function set pageSize(value:Number):void
		{
			if(pageSize == value){
				return;
			}
			var prevPageViewDiff:Number = calcPageViewSizeDiff();
			_pageSize = value;
			updateThumbHeight(prevPageViewDiff);
		}
		
		public function get value():Number
		{
			return scrollV * (maxValue - minValue) + minValue;
		}
		
		public function set value(newValue:Number):void
		{
			scrollV = (newValue - minValue) / (maxValue - minValue);
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			switch(value)
			{
				case "horizontal":
				case "vertical":
					_type = value;
					break;
				default:
					throw new Error("invalid value");
			}
		}
	}
}