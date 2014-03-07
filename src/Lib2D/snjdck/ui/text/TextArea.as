package snjdck.ui.text
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import snjdck.ui.Slider;

	public class TextArea extends Sprite
	{
		private var labelTf:TextField;
		private var _scrollBar:Slider;
		
		public function TextArea()
		{
			createChildren();
			scrollBar.addEventListener(Event.SCROLL, __onScroll);
			addEventListener(MouseEvent.MOUSE_WHEEL, __onMouseWheel);
			labelTf.addEventListener(Event.CHANGE, __onViewAreaChange);
		}
		
		public function get editMode():Boolean
		{
			return TextFieldType.INPUT == labelTf.type;
		}
		
		public function set editMode(value:Boolean):void
		{
			if(editMode != value){
				labelTf.type = value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			}
		}
		
		public function get scrollBar():Slider
		{
			return _scrollBar;
		}
		
		protected function createChildren():void
		{
			labelTf.multiline = true;
			labelTf.wordWrap = true;
			
			_scrollBar = new Slider();
			
			scrollBar.x = width;
			scrollBar.height = height;
			scrollBar.visible = false;
			
			addChild(scrollBar);
		}
		
		private function __onViewAreaChange(event:Event):void
		{
			scrollBar.viewSize = labelTf.bottomScrollV - labelTf.scrollV + 1;
			scrollBar.pageSize = labelTf.numLines;
			scrollBar.visible = scrollBar.canScroll();
		}
		
		private function __onScroll(event:Event):void
		{
			labelTf.scrollV = 1 + Math.round((labelTf.maxScrollV - 1) * scrollBar.scrollV);
		}
		
		private function __onMouseWheel(event:MouseEvent):void
		{
			scrollBar.scroll(-event.delta);
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			scrollBar.x = width - scrollBar.width;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			scrollBar.height = height;
		}
		
		public function set text(value:String):void
		{
			labelTf.text = value;
			__onViewAreaChange(null);
		}
		
		public function appendText(newText:String):void
		{
			labelTf.appendText(newText);
			__onViewAreaChange(null);
		}
	}
}