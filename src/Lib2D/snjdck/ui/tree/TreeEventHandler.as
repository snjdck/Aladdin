package snjdck.ui.tree
{
	import flash.display.Stage;
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
		
		private function get stage():Stage
		{
			return tree.labelTxt.stage;
		}
		
		private function init():void
		{
			labelTxt.addEventListener(MouseEvent.CLICK, __onClick);
			labelTxt.addEventListener(MouseEvent.DOUBLE_CLICK, __onDoubleClick);
			labelTxt.addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
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
		
		private function __onMouseDown(evt:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
		}
		
		private function __onMouseMove(evt:MouseEvent):void
		{
			__onMouseUp(evt);
			root.dragSignal.notify(tree._dataProvider);
		}
		
		private function __onMouseUp(evt:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
		}
	}
}