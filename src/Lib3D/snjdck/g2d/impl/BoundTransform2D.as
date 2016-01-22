package snjdck.g2d.impl
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import bound2d.union;
	
	import matrix33.transformBound;

	internal class BoundTransform2D extends Transform2D
	{
		static private const tempMatrix:Matrix = new Matrix();
		private const tempBound:Rectangle = new Rectangle();
		
		private var _isBoundDirty:Boolean;
		private const _bound:Rectangle = new Rectangle();
		
		private var useExplicitWidth:Boolean;
		private var explicitWidth:Number;
		private var useExplicitHeight:Boolean;
		private var explicitHeight:Number;
		
		public function BoundTransform2D(){}
		
		protected function get useExplicitSize():Boolean
		{
			return useExplicitWidth && useExplicitHeight;
		}
		
		protected function markBoundDirty():void
		{
			if(_isBoundDirty)
				return;
			_isBoundDirty = true;
			markParentBoundDirty();
		}
		
		protected function markParentBoundDirty():void
		{
			var parent:BoundTransform2D = getParent() as BoundTransform2D;
			if(parent != null && !parent.useExplicitSize){
				parent.markBoundDirty();
			}
		}
		
		public function get width():Number
		{
			return bound.width;
		}
		
		public function set width(value:Number):void
		{
			useExplicitWidth = true;
			explicitWidth = value;
			if(_bound.width == value)
				return;
			_bound.width = value;
			markBoundDirty();
		}
		
		public function get height():Number
		{
			return bound.height;
		}
		
		public function set height(value:Number):void
		{
			useExplicitHeight = true;
			explicitHeight = value;
			if(_bound.height == value)
				return;
			_bound.height = value;
			markBoundDirty();
		}
		
		override protected function onLocalMatrixDirty():void
		{
			markParentBoundDirty();
		}
		
		public function get bound():Rectangle
		{
			if(_isBoundDirty && getChildren() && !useExplicitSize)
				calculateRelativeBound(this, _bound);
			_isBoundDirty = false;
			return _bound;
		}
		
		protected function calculateRelativeBound(target:Transform2D, result:Rectangle):void
		{
			var childList:Array = getChildren();
			if(childList == null || useExplicitSize){
				calculateRelativeTransform(target, tempMatrix);
				transformBound(tempMatrix, _bound, result);
				return;
			}
			result.setEmpty();
			for each(var child:BoundTransform2D in childList){
				if(child.isVisible()){
					child.calculateRelativeBound(target, tempBound);
					union(result, tempBound, result);
				}
			}
			if(useExplicitWidth){
				result.width = explicitWidth;
			}else if(useExplicitHeight){
				result.height = explicitHeight;
			}
		}
	}
}