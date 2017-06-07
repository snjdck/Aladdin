package snjdck.ui.tree
{
	import flash.display.Sprite;
	import flash.signals.Signal;
	
	public class Tree extends Sprite
	{
		static private const pool:Array = [];
		
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
			while(numChildren > 0){
				putLabel(getChildAt(numChildren-1) as TreeLabel);
			}
			rootTree.dataProvider = value;
			nextY = 0;
			rootTree.drawChildren();
		}
		
		internal function getLabel(node:TreeImpl):TreeLabel
		{
			var tf:TreeLabel = pool.length > 0 ? pool.pop() : new TreeLabel();
			addChild(tf);
			tf.tree = node;
			return tf;
		}
		
		internal function putLabel(tf:TreeLabel):void
		{
			tf.tree = null;
			removeChild(tf);
			pool.push(tf);
		}
	}
}