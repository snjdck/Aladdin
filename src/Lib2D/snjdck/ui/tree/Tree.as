package snjdck.ui.tree
{
	import flash.display.Sprite;
	import flash.signals.Signal;
	
	public class Tree extends Sprite
	{
		private var rootTree:TreeImpl;
		internal var nextY:int;
		
		public const clickSignal:Signal = new Signal(XML);
		public const doubleClickSignal:Signal = new Signal(XML);
		public const dragSignal:Signal = new Signal(XML);
		
		public function Tree()
		{
			rootTree = new TreeImpl(this, null);
		}
		
		public function set dataProvider(value:XML):void
		{
			removeChildren();
			rootTree.dataProvider = value;
			nextY = 0;
			rootTree.drawChildren();
		}
	}
}