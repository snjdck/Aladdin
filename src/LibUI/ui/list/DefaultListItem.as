package ui.list
{
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	
	import ui.text.Label;
	
	public class DefaultListItem extends ListItem
	{
		private var _label:Label;
		private var isRollOver:Boolean;
		
		public function DefaultListItem()
		{
			_label = new Label();
			addChild(_label);
			addEventListener(MouseEvent.ROLL_OVER, __onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, __onRollOut);
			drawSelf(0xFF0000, 0);
		}
		
		private function drawSelf(color:uint, alpha:Number):void
		{
			var g:Graphics = graphics;
			g.clear();
			g.beginFill(color, alpha);
			g.drawRect(0, 0, width, height);
			g.endFill();
		}
		
		override public function onFocusIn():void
		{
			super.onFocusIn();
			if(!isRollOver){
				drawSelf(0xFF00, 0.5);
			}
		}
		
		override public function onFocusOut():void
		{
			super.onFocusOut();
			drawSelf(0xFF0000, 0);
		}
		
		
		private function __onRollOver(event:MouseEvent):void
		{
			isRollOver = true;
			drawSelf(0xFF0000, 0.5);
		}
		
		private function __onRollOut(event:MouseEvent):void
		{
			isRollOver = false;
			if(isFocus()){
				drawSelf(0xFF00, 0.5);
			}else{
				drawSelf(0xFF0000, 0);
			}
		}
		
		override public function set data(value:Object):void
		{
			_label.text = value.toString();
		}
	}
}