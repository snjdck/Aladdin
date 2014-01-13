package snjdck.display.d2
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	public class AlphaBitmap extends InteractiveBitmap
	{
		private var isMouseOver:Boolean;
		
		public function AlphaBitmap(bitmapData:BitmapData=null)
		{
			super(bitmapData);
			
			addListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			addListener(MouseEvent.MOUSE_OVER, __onMouseOver);
			addListener(MouseEvent.MOUSE_OUT, __onMouseOut);
			
			addListener(MouseEvent.MOUSE_DOWN, __hookMouseEvt);
			addListener(MouseEvent.MOUSE_UP, __hookMouseEvt);
			addListener(MouseEvent.CLICK, __hookMouseEvt);
		}
		
		private function __onMouseMove(evt:MouseEvent):void
		{
			if(
				isMouseOver != ((bitmapData.getPixel32(mouseX, mouseY) >>> 24) > 0)//alpha > 0
			){
				isMouseOver = !isMouseOver;
				notifyEvt(evt, isMouseOver?MouseEvent.MOUSE_OVER:MouseEvent.MOUSE_OUT);
			}
			
			if(!isMouseOver){
				evt.stopImmediatePropagation();
			}
		}
		
		private function __onMouseOver(evt:MouseEvent):void
		{
			if(!evt.cancelable){
				evt.stopImmediatePropagation();
			}
		}
		
		private function __onMouseOut(evt:MouseEvent):void
		{
			if(isMouseOver || evt.cancelable){
				isMouseOver = false;
			}else{
				evt.stopImmediatePropagation();
			}
		}
		
		private function __hookMouseEvt(evt:MouseEvent):void
		{
			if(!isMouseOver){
				evt.stopImmediatePropagation();
			}
		}
		
		private function addListener(evtType:String, listener:Function):void
		{
			addEventListener(evtType, listener, false, int.MAX_VALUE);
		}
		
		private function notifyEvt(evt:MouseEvent, evtType:String):void
		{
			dispatchEvent(new MouseEvent(
				evtType,
				evt.bubbles,
				true,
				evt.localX, evt.localY,
				evt.relatedObject,
				evt.ctrlKey, evt.altKey, evt.shiftKey,
				evt.buttonDown,
				evt.delta
			));
		}
	}
}