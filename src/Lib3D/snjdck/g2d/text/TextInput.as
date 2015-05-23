package snjdck.g2d.text
{
	import flash.events.MouseEvent;
	
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.impl.DisplayObjectContainer2D;
	import snjdck.g2d.render.Render2D;
	import snjdck.g2d.text.ime.ImeMgr;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g2d;

	public class TextInput extends DisplayObjectContainer2D
	{
		private var label:Label;
		
		public function TextInput()
		{
			label = new Label();
			addChild(label);
			
			width = label.width;
			height = label.height;
			mouseChildren = false;
			addListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
		}
		
		private function __onMouseDown(target:TextInput):void
		{
			ImeMgr.Instance.activeIME();
			ImeMgr.Instance.updateSignal.add(updateText);
			ImeMgr.Instance.caret.parent = this;
		}
		
		private function updateText(value:String):void
		{
			label.text = value;
		}
		
		override public function onUpdate(timeElapsed:int):void
		{
			if(ImeMgr.Instance.isActive){
				ImeMgr.Instance.caret.x = ImeMgr.Instance.caretIndex * 12;
			}
			super.onUpdate(timeElapsed);
		}
		
		public function set text(value:String):void
		{
			label.text = value;
		}
	}
}