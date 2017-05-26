package snjdck.editor.menu
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.ContextMenuEvent;

	public class EditItemMenu extends ContextMenuBase
	{
		static public const Instance:EditItemMenu = new EditItemMenu();
		
		public function EditItemMenu()
		{
			addItem("移到顶层", __onTopMost);
			addItem("上移一层", __onTop);
			addItem("下移一层", __onBottom);
			addItem("移到底层", __onBottomMost);
		}
		
		private function __onTopMost(evt:ContextMenuEvent):void
		{
			var target:DisplayObject = getTarget(evt);
			var parent:DisplayObjectContainer = target.parent;
			var index:int = parent.getChildIndex(target);
			if(index < parent.numChildren - 1){
				parent.setChildIndex(target, parent.numChildren-1);
			}
		}
		
		private function __onTop(evt:ContextMenuEvent):void
		{
			var target:DisplayObject = getTarget(evt);
			var parent:DisplayObjectContainer = target.parent;
			var index:int = parent.getChildIndex(target);
			if(index < parent.numChildren - 1){
				parent.setChildIndex(target, index + 1);
			}
		}
		
		private function __onBottom(evt:ContextMenuEvent):void
		{
			var target:DisplayObject = getTarget(evt);
			var parent:DisplayObjectContainer = target.parent;
			var index:int = parent.getChildIndex(target);
			if(index > 0){
				parent.setChildIndex(target, index - 1);
			}
		}
		
		private function __onBottomMost(evt:ContextMenuEvent):void
		{
			var target:DisplayObject = getTarget(evt);
			var parent:DisplayObjectContainer = target.parent;
			var index:int = parent.getChildIndex(target);
			if(index > 0){
				parent.setChildIndex(target, 0);
			}
		}
	}
}