package snjdck.g3d.terrain
{
	import snjdck.g3d.bound.AABB;
	import snjdck.g3d.obj3d.Entity;
	import snjdck.quadtree.IQuadTreeNode;
	
	internal class SceneItem implements IQuadTreeNode
	{
		public var entity:Entity;
		public var bound:AABB = new AABB();
		
		public function SceneItem(entity:Entity)
		{
			this.entity = entity;
			bound.copyFrom(entity.bound);
		}
		
		public function get x():Number
		{
			return bound.minX;
		}
		
		public function get y():Number
		{
			return bound.minY;
		}
		
		public function get width():Number
		{
			return bound.halfSize.x * 2;
		}
		
		public function get height():Number
		{
			return bound.halfSize.y * 2;
		}
		
		public function getBound():AABB
		{
			return bound;
		}
	}
}