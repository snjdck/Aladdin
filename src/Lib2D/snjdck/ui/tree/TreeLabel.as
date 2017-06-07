package snjdck.ui.tree
{
	import flash.display.Sprite;
	import flash.events.DragStartEventListener;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import snjdck.ui.utils.TextFieldFactory;
	
	internal class TreeLabel extends Sprite
	{
		private var _tree:TreeImpl;
		private var labelTxt:TextField;
		
		public function TreeLabel()
		{
			labelTxt = TextFieldFactory.Create(this);
			labelTxt.addEventListener(MouseEvent.CLICK, __onClick);
			labelTxt.addEventListener(MouseEvent.DOUBLE_CLICK, __onDoubleClick);
			new DragStartEventListener(labelTxt, __onDragStart);
		}

		private function get root():Tree
		{
			return tree.root;
		}
		
		internal function get tree():TreeImpl
		{
			return _tree;
		}

		internal function set tree(value:TreeImpl):void
		{
			_tree = value;
			if(_tree != null){
				labelTxt.doubleClickEnabled = !_tree.isBranch();
				labelTxt.text = _tree._dataProvider.@label;
			}
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