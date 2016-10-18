package snjdck.g3d.entities
{
	import snjdck.g3d.bounds.AABB;
	import snjdck.g3d.core.Object3D;

	internal class EntityBound
	{
		private const _worldBound:AABB = new AABB();
		private const _localBound:AABB = new AABB();
		private var isWorldBoundDirty:Boolean = true;
		
		private var target:Object3D;
		
		public function EntityBound(target:Object3D)
		{
			this.target = target;
		}
		
		public function markWorldBoundDirty():void
		{
			isWorldBoundDirty = true;
		}
		
		public function get localBound():AABB
		{
			return _localBound;
		}
		
		public function get worldBound():AABB
		{
			if(isWorldBoundDirty){
				_localBound.transform(target.worldTransform, _worldBound);
				isWorldBoundDirty = false;
			}
			return _worldBound;
		}
	}
}