package snjdck.g2d.text
{
	import flash.events.MouseEvent;
	import flash.text.ime.IIMEClient;
	
	import snjdck.g2d.ns_g2d;
	import snjdck.g2d.obj2d.Image;
	import snjdck.g2d.render.Render2D;
	import snjdck.g2d.text.ime.IMEClient;
	import snjdck.g2d.text.ime.ImeMgr;
	import snjdck.gpu.asset.GpuContext;
	
	use namespace ns_g2d;

	public class TextInput extends Label
	{
		ns_g2d var imeClient:IIMEClient;
		public var caretIndex:int;
		
		public function TextInput()
		{
			imeClient = new IMEClient(prevWorldMatrix);
			addListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
		}
		
		private function __onMouseDown(target:TextInput):void
		{
			caretIndex = 0;
			ImeMgr.Instance.activeIME(this);
		}
		
		override public function hasVisibleArea():Boolean
		{
			return visible;
		}
		
		override protected function onDraw(render2d:Render2D, context3d:GpuContext):void
		{
			if(Boolean(text)){
				super.onDraw(render2d, context3d);
			}
			if(ImeMgr.Instance.isFocus(this) && ImeMgr.Instance.caret.visible){
				var caret:Image = ImeMgr.Instance.caret;
				charList.calcPosition(text, caretIndex, width, tempPt);
				caret.x = tempPt.x;
				caret.y = tempPt.y;
				caret.prevWorldMatrix.copyFrom(caret.transform);
				caret.prevWorldMatrix.concat(prevWorldMatrix);
				caret.draw(render2d, context3d);
			}
		}
		
		ns_g2d function addChar(inputText:String):void
		{
			if(caretIndex <= 0){
				text = inputText + text;
			}else if(caretIndex >= text.length){
				text += inputText;
			}else{
				text = text.slice(0, caretIndex) + inputText + text.slice(caretIndex);
			}
			caretIndex += inputText.length;
		}
		
		ns_g2d function removeChar():void
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
		}
		
		ns_g2d function moveCaretLeft():void
		{
			if(caretIndex > 0){
				--caretIndex;
			}
		}
		
		ns_g2d function moveCaretRight():void
		{
			if(caretIndex < text.length){
				++caretIndex;
			}
		}
		
		ns_g2d function moveCaretUp():void
		{
			caretIndex = charList.moveCaretUp(caretIndex);
		}
		
		ns_g2d function moveCaretDown():void
		{
			caretIndex = charList.moveCaretDown(caretIndex);
		}
		
		ns_g2d function moveCaretToBegin():void
		{
			caretIndex = 0;
		}
		
		ns_g2d function moveCaretToEnd():void
		{
			caretIndex = text.length;
		}
	}
}