package ui.text
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	
	import ui.Slider;

	public class TextArea extends TextComponent
	{
		private var _scrollBar:Slider;
		
		public function TextArea()
		{
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
		
		override protected function createChildren():void
		{
			super.createChildren();
			
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
		
		override public function set text(value:String):void
		{
			super.text = value;
			__onViewAreaChange(null);
		}
		
		override public function appendText(newText:String):void
		{
			super.appendText(newText);
			__onViewAreaChange(null);
		}
	}
}