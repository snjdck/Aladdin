package snjdck.ui.tree
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TreeImpl
	{
		private var childList:Array = [];
		private var parent:TreeImpl;
		private var root:Tree;
		private var level:int;
		private var _dataProvider:XML;
		
		private var _expandFlag:Boolean;
		
		private var labelTxt:TextField;
		
		public function TreeImpl(root:Tree, parent:TreeImpl, level:int=0)
		{
			this.parent = parent;
			this.root = root;
			this.level = level;
			
			labelTxt = new TextField();
			labelTxt.autoSize = TextFieldAutoSize.LEFT;
			labelTxt.selectable = false;
			labelTxt.defaultTextFormat = new TextFormat("微软雅黑", 12);
			root.addChild(labelTxt);
			
			labelTxt.addEventListener(MouseEvent.CLICK, __onClick);
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

		private function isBranch():Boolean
		{
			return _dataProvider.hasComplexContent();
		}
		
		private function __onClick(evt:MouseEvent):void
		{
			if(isBranch()){
				expandFlag = !expandFlag;
			}else{
				root.clickSignal.notify(_dataProvider);
			}
		}
		
		internal function drawChildren(from:TreeImpl=null):void
		{
			var index:int = from ? childList.indexOf(from) + 1 : 0;
			for(var i:int=index, n:int=childList.length; i<n; ++i){
				var child:TreeImpl = childList[i];
				child.draw();
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
			for(var i:int=0, n:int=childList.length; i<n; ++i){
				var child:TreeImpl = childList[i];
				child.draw(visible && expandFlag);
			}
		}
		
		public function set dataProvider(value:XML):void
		{
			_dataProvider = value;
			childList.length = 0;
			if(value.hasComplexContent()){
				for each(var node:XML in value.children()){
					var child:TreeImpl = new TreeImpl(root, this, level + 1);
					child.dataProvider = node;
					childList.push(child);
				}
			}
		}
	}
}