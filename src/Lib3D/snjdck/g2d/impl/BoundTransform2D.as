package snjdck.g2d.impl
{
	import flash.geom.Rectangle;
	
	import matrix33.transformBound;
	
	import snjdck.g2d.ns_g2d;
	
	use namespace ns_g2d;

	internal class BoundTransform2D extends Transform2D
	{
		private var _isOriginalBoundDirty:Boolean;
		private var _isDeformedBoundDirty:Boolean;
		private const _originalBound:Rectangle = new Rectangle();
		private const _deformedBound:Rectangle = new Rectangle();
		
		public function BoundTransform2D(){}
		
		override protected function onLocalMatrixDirty():void
		{
			_isDeformedBoundDirty = true;
			markParentBoundDirty();
		}
		
		protected function get isOriginalBoundDirty():Boolean
		{
			return _isOriginalBoundDirty;
		}
		
		final ns_g2d function markOriginalBoundDirty():void
		{
			if(_isOriginalBoundDirty)
				return;
			_isOriginalBoundDirty = true;
			_isDeformedBoundDirty = true;
			markParentBoundDirty();
		}
		
		virtual protected function markParentBoundDirty():void{}
		
		protected function get originalBound():Rectangle
		{
			_isOriginalBoundDirty = false;
			return _originalBound;
		}
		
		public function get deformedBound():Rectangle
		{
			if(_isDeformedBoundDirty){
				transformBound(transform, originalBound, _deformedBound);
				_isDeformedBoundDirty = false;
			}
			return _deformedBound;
		}
	}
}