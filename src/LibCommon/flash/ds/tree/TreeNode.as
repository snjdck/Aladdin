package flash.ds.tree
{
	public class TreeNode
	{
		protected var _firstChild:TreeNode;
		protected var _nextSibling:TreeNode;
		
		public function TreeNode()
		{
		}

		public function get firstChild():*
		{
			return _firstChild;
		}
		
		public function get nextSibling():*
		{
			return _nextSibling;
		}

		public function get lastSibling():TreeNode
		{
			var testNode:TreeNode = this;
			while(testNode._nextSibling){
				testNode = testNode._nextSibling;
			}
			return testNode;
		}
		
		public function addChild(child:TreeNode):void
		{
			if(_firstChild){
				_firstChild.addSibling(child);
			}else{
				_firstChild = child;
			}
		}
		
		public function addSibling(sibling:TreeNode):void
		{
			lastSibling._nextSibling = sibling;
		}
	}
}