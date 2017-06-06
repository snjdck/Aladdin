package snjdck.ui.tree
{
	import flash.text.TextField;
	
	import snjdck.ui.utils.TextFieldFactory;

	internal class TreeImpl
	{
		private var firstChild:TreeImpl;
		private var nextSibling:TreeImpl;
		private var parent:TreeImpl;
		internal var root:Tree;
		private var level:int;
		internal var _dataProvider:XML;
		
		private var _expandFlag:Boolean;
		
		internal var labelTxt:TextField;
		
		public function TreeImpl(root:Tree, parent:TreeImpl, level:int=0)
		{
			this.parent = parent;
			this.root = root;
			this.level = level;
			
			labelTxt = TextFieldFactory.Create(root);
			
			new TreeEventHandler(this);
		}
		
		public function get expandFlag():Boolean
		{
			return _expandFlag;
		}

		public function set expandFlag(value:Boolean):void
		{
			_expandFlag = value;
			if(parent != null){
				root.nextY = labelTxt.y;
				draw();
				parent.drawChildren(this);
			}
		}

		public function isBranch():Boolean
		{
			return _dataProvider.hasComplexContent();
		}
		
		internal function drawChildren(from:TreeImpl=null):void
		{
			var child:TreeImpl = from ? from.nextSibling : firstChild;
			while(child != null){
				child.draw();
				child = child.nextSibling;
			}
			if(parent != null){
				parent.drawChildren(this);
			}
		}
		
		private function draw(visible:Boolean=true):void
		{
			labelTxt.visible = visible;
			if(visible){
				labelTxt.text = _dataProvider.@label;
				labelTxt.x = level * 10;
				labelTxt.y = root.nextY;
				root.nextY += labelTxt.height;
			}
			var child:TreeImpl = firstChild;
			while(child != null){
				child.draw(visible && expandFlag);
				child = child.nextSibling;
			}
		}
		
		public function set dataProvider(value:XML):void
		{
			firstChild = null;
			_dataProvider = value;
			if(isBranch()){
				var prevSibling:TreeImpl;
				for each(var node:XML in value.children()){
					var child:TreeImpl = new TreeImpl(root, this, level + 1);
					child.dataProvider = node;
					if(prevSibling != null){
						prevSibling.nextSibling = child;
					}else{
						firstChild = child;
					}
					prevSibling = child;
				}
			}
			labelTxt.doubleClickEnabled = !isBranch();
		}
	}
}