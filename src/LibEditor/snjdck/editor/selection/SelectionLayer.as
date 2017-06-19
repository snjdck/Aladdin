package snjdck.editor.selection
{
	import flash.display.DisplayObject;
	import flash.display.ImageControl;
	import flash.display.Sprite;
	import flash.events.DragEventListener;
	import flash.events.MouseEvent;
	
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
				addChild(selection);
				var listener:DragEventListener = new DragEventListener(selection);
				listener.onBegin = __onBegin;
				listener.onMove = __onMove;
				listener.onClick = [__onClick, target];
				targetList.push(target);
			}else{
				removeChildAt(index);
				targetList.removeAt(index);
			}
		}
		
		private function __onClick(evt:MouseEvent, target:DisplayObject):void
		{
			if(evt.shiftKey){
				var index:int = targetList.indexOf(target);
				removeChildAt(index);
				targetList.removeAt(index);
			}else{
				clearAll();
				control.setTarget(target, false);
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
		
		private function __onBegin():void
		{
			for(var i:int=numChildren-1; i>=0; --i){
				var layer:SelectionTarget = getChildAt(i) as SelectionTarget;
				layer.saveTargetXY();
			}
		}
		private function __onMove(dx:Number, dy:Number):void
		{
			for(var i:int=numChildren-1; i>=0; --i){
				var layer:SelectionTarget = getChildAt(i) as SelectionTarget;
				layer.updateTargetXY(dx, dy);
			}
		}
	}
}