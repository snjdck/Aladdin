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
		
		protected var useExplicitWidth:Boolean;
		protected var explicitWidth:Number;
		protected var useExplicitHeight:Boolean;
		protected var explicitHeight:Number;
		
		public function BoundTransform2D(){}
		
		override protected function onLocalMatrixDirty():void
		{
			_isDeformedBoundDirty = true;
			markParentBoundDirty();
		}
		
		final ns_g2d function markBoundDirty():void
		{
			if(_isOriginalBoundDirty)
				return;
			_isOriginalBoundDirty = true;
			_isDeformedBoundDirty = true;
			markParentBoundDirty();
		}
		
		final ns_g2d function markParentBoundDirty():void
		{
			var parent:BoundTransform2D = getParent() as BoundTransform2D;
			if(parent != null && !(parent.useExplicitWidth && parent.useExplicitHeight)){
				parent.markBoundDirty();
			}
		}
		
		public function get originalBound():Rectangle
		{
			var childList:Array = getChildren();
			if(childList == null){
				_isOriginalBoundDirty = false;
				return _originalBound;
			}
			if(useExplicitWidth && useExplicitHeight){
				return _originalBound;
			}
			if(_isOriginalBoundDirty){
				_originalBound.setEmpty();
				for each(var child:BoundTransform2D in childList){
					if(child.isVisible()){
						_originalBound.union(child.deformedBound);
					}
				}
				_isOriginalBoundDirty = false;
			}
			if(useExplicitWidth){
				_originalBound.width = explicitWidth;
			}else if(useExplicitHeight){
				_originalBound.height = explicitHeight;
			}
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