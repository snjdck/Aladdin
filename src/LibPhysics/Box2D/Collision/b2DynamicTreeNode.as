package Box2D.Collision 
{
	/**
	 * A node in the dynamic tree. The client does not interact with this directly.
	 * @private
	 */
	public class b2DynamicTreeNode 
	{
		public function IsLeaf():Boolean
		{
			return child1 == null;
		}
		
		public var aabb:b2AABB = new b2AABB();
		public var userData:*;
		
		public var parent:b2DynamicTreeNode;
		public var child1:b2DynamicTreeNode;
		public var child2:b2DynamicTreeNode;
	}
}