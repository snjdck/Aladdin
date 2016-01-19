package snjdck.g2d.impl
{
	import flash.geom.Rectangle;
	
	import matrix33.transformBound;

	internal class BoundTransform2D extends Transform2D
	{
		private var isWorldBoundDirty:Boolean;
		private var isLocalBoundDirty:Boolean;
		private const _originalBound:Rectangle = new Rectangle();
		private const _worldBound:Rectangle = new Rectangle();
		private const _localBound:Rectangle = new Rectangle();
		
		public function BoundTransform2D(){}
		
		protected function get originalBound():Rectangle
		{
			return _originalBound;
		}
		
		protected function set originalBound(value:Rectangle):void
		{
			_originalBound.copyFrom(value);
			markOriginalBoundDirty();
		}
		
		protected function markOriginalBoundDirty():void
		{
			isWorldBoundDirty = true;
			isLocalBoundDirty = true;
		}
		
		override internal function markWorldMatrixDirty():void
		{
			super.markWorldMatrixDirty();
			isWorldBoundDirty = true;
		}
		
		override protected function markLocalMatrixDirty():void
		{
			super.markLocalMatrixDirty();
			isLocalBoundDirty = true;
		}
		
		public function get bound():Rectangle
		{
			if(isLocalBoundDirty){
				transformBound(transform, originalBound, _localBound);
				isLocalBoundDirty = false;
			}
			return _localBound;
		}
		
		public function get worldBound():Rectangle
		{
			if(isWorldBoundDirty){
				transformBound(worldTransform, originalBound, _worldBound);
				isWorldBoundDirty = false;
			}
			return _worldBound;
		}
	}
}