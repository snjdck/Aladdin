package snjdck.editor.selection
{
	import flash.display.DisplayObject;
	import flash.display.ImageControl;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import snjdck.GDI;
	
	public class SelectionLayer extends Sprite
	{
		private var control:ImageControl;
		private var targetList:Array = [];
		
		public function SelectionLayer(control:ImageControl)
		{
			this.control = control;
			mouseEnabled = false;
		}
		
		public function getTargetList():Array
		{
			return targetList.slice();
		}
		
		public function toggleSelection(target:DisplayObject):void
		{
			var index:int = targetList.indexOf(target);
			if(index < 0){
				var selection:SelectionTarget = new SelectionTarget(target);
				selection.addEventListener(MouseEvent.MOUSE_DOWN, __onClick);
				addChild(selection);
				targetList.push(target);
			}else{
				removeChildAt(index);
				targetList.removeAt(index);
			}
		}
		
		private function __onClick(evt:MouseEvent):void
		{
			var target:DisplayObject = (evt.currentTarget as SelectionTarget).target;
			if(evt.shiftKey){
				var index:int = targetList.indexOf(target);
				removeChildAt(index);
				targetList.removeAt(index);
				
			}else{
				clearAll();
				control.setTarget(target);
			}
		}
		
		public function addSelection(target:DisplayObject):void
		{
			
		}
		
		public function delSelection(target:DisplayObject):void
		{
			
		}
		
		public function clearAll():void
		{
			targetList.length = 0;
			removeChildren();
		}
	}
}