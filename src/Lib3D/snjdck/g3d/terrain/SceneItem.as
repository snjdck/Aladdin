package snjdck.g3d.terrain
{
	import snjdck.g3d.bounds.AABB;
	import snjdck.g3d.entities.IEntity;
	import snjdck.quadtree.IQuadTreeItem;
	
	internal class SceneItem implements IQuadTreeItem
	{
		public var entity:IEntity;
		public var bound:AABB = new AABB();;
		
		public function SceneItem(entity:IEntity)
		{
			this.entity = entity;
			bound.copyFrom(entity.worldBound);
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