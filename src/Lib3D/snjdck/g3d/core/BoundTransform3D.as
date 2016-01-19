package snjdck.g3d.core
{
	import snjdck.g3d.ns_g3d;
	import snjdck.g3d.bound.AABB;
	
	use namespace ns_g3d;

	internal class BoundTransform3D extends Transform3D
	{
		private var isWorldBoundDirty:Boolean;
		private var isLocalBoundDirty:Boolean;
		private const _originalBound:AABB = new AABB();
		private const _worldBound:AABB = new AABB();
		private const _localBound:AABB = new AABB();
		
		public function BoundTransform3D(){}
		
		protected function get originalBound():AABB
		{
			return _originalBound;
		}
		
		protected function set originalBound(value:AABB):void
		{
			_originalBound.copyFrom(value);
			markOriginalBoundDirty();
		}
		
		protected function markOriginalBoundDirty():void
		{
			isWorldBoundDirty = true;
			isLocalBoundDirty = true;
		}
		
		override ns_g3d function markWorldMatrixDirty():void
		{
			super.markWorldMatrixDirty();
			isWorldBoundDirty = true;
		}
		
		override protected function markLocalMatrixDirty():void
		{
			super.markLocalMatrixDirty();
			isLocalBoundDirty = true;
		}
		
		public function get bound():AABB
		{
			if(isLocalBoundDirty){
				originalBound.transform(transform, _localBound);
				isLocalBoundDirty = false;
			}
			return _localBound;
		}
		
		public function get worldBound():AABB
		{
			if(isWorldBoundDirty){
				originalBound.transform(worldTransform, _worldBound);
				isWorldBoundDirty = false;
			}
			return _worldBound;
		}
	}
}