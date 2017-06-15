package snjdck.editor.selection
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import snjdck.GDI;
	
	public class SelectionLayer extends Sprite
	{
		private var targetList:Array = [];
		
		public function SelectionLayer()
		{
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
				selection.clickSignal.add(__onClick);
				addChild(selection);
				targetList.push(target);
			}else{
				removeChildAt(index);
				targetList.removeAt(index);
			}
		}
		
		private function __onClick(target:DisplayObject):void
		{
			var index:int = targetList.indexOf(target);
			removeChildAt(index);
			targetList.removeAt(index);
		}
		
		public function addSelection(target:DisplayObject):void
		{
			
		}
		
		public function delSelection(target:DisplayObject):void
		{
			
		}
		
		public function clearAll():void
		{
			
		}
	}
}