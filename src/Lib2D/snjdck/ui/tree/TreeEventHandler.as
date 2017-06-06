package snjdck.ui.tree
{
	import flash.events.DragStartEventListener;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	internal class TreeEventHandler
	{
		private var tree:TreeImpl;
		
		public function TreeEventHandler(tree:TreeImpl)
		{
			this.tree = tree;
			init();
		}
		
		private function get labelTxt():TextField
		{
			return tree.labelTxt;
		}
		
		private function get root():Tree
		{
			return tree.root;
		}
		
		private function init():void
		{
			labelTxt.addEventListener(MouseEvent.CLICK, __onClick);
			labelTxt.addEventListener(MouseEvent.DOUBLE_CLICK, __onDoubleClick);
			new DragStartEventListener(labelTxt, __onDragStart);
		}
		
		private function __onClick(evt:MouseEvent):void
		{
			if(tree.isBranch()){
				tree.expandFlag = !tree.expandFlag;
			}else{
				root.clickSignal.notify(tree._dataProvider);
			}
		}
		
		private function __onDoubleClick(evt:MouseEvent):void
		{
			if(!tree.isBranch()){
				root.doubleClickSignal.notify(tree._dataProvider);
			}
		}
		
		private function __onDragStart():void
		{
			root.dragSignal.notify(tree._dataProvider);
		}
	}
}