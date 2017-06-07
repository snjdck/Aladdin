package snjdck.ui.layout
{
	import flash.display.DisplayObject;
	
	import snjdck.ui.Component;

	public class LayoutObject extends Component
	{
		static private const layoutMgr:LayoutManager = new LayoutManager();
		
		private var _centerX:Number;
		private var _centerY:Number;
		
		private var _left:Number;
		private var _right:Number;
		
		private var _top:Number;
		private var _bottom:Number;
		
		private var isLayoutXDirty:Boolean;
		private var isLayoutYDirty:Boolean;
		
		public function LayoutObject(){}
		
		public function get parentWidth():Number
		{
			switch(parent){
				case stage:
				case root:
					return stage.stageWidth;
			}
			return parent.width;
		}
		
		public function get parentHeight():Number
		{
			switch(parent){
				case stage:
				case root:
					return stage.stageHeight;
			}
			return parent.width;
		}
		
		public function reLayout():void
		{
			var wFlag:Boolean = false;
			var hFlag:Boolean = false;
			if(isLayoutXDirty){
				if(!isNaN(_centerX)){
					x = 0.5 * (parentWidth - width) + _centerX;
				}else if(!isNaN(_left)){
					x = _left;
					if(!isNaN(_right)){
						super.width = parentWidth - (_left + _right);
						wFlag = true;
					}
				}else if(!isNaN(_right)){
					x = (parentWidth - width) - _right;
				}
				isLayoutXDirty = false;
			}
			if(isLayoutYDirty){
				if(!isNaN(_centerY)){
					y = 0.5 * (parentHeight - height) + _centerY;
				}else if(!isNaN(_top)){
					y = _top;
					if(!isNaN(_bottom)){
						super.height = parentHeight - (_top + _bottom);
						hFlag = true;
					}
				}else if(!isNaN(_bottom)){
					y = (parentHeight - height) - _bottom;
				}
				isLayoutYDirty = false;
			}
			if(wFlag || hFlag){
				onSizeChanged(wFlag, hFlag);
			}
			for(var i:int=0, n:int=numChildren; i<n; ++i){
				var child:LayoutObject = getChildAt(i) as LayoutObject;
				if(child != null && child.visible){
					child.reLayout();
				}
			}
		}
		
		private function invalidateLayout():void
		{
			if(!(isLayoutXDirty || isLayoutYDirty)){
				layoutMgr.requestUpdate(this);
			}
		}
		
		private function invalidateLayoutX(markChildren:Boolean=true):void
		{
			invalidateLayout();
			isLayoutXDirty = true;
			if(markChildren){
				markChildrenLayoutXDirty();
			}
		}
		
		private function invalidateLayoutY(markChildren:Boolean=true):void
		{
			invalidateLayout();
			isLayoutYDirty = true;
			if(markChildren){
				markChildrenLayoutYDirty();
			}
		}
		
		private function markChildrenLayoutXDirty():void
		{
			for(var i:int=0, n:int=numChildren; i<n; ++i){
				var child:LayoutObject = getChildAt(i) as LayoutObject;
				if(child != null){
					child.isLayoutXDirty = true;
					child.markChildrenLayoutXDirty();
				}
			}
		}
		
		private function markChildrenLayoutYDirty():void
		{
			for(var i:int=0, n:int=numChildren; i<n; ++i){
				var child:LayoutObject = getChildAt(i) as LayoutObject;
				if(child != null){
					child.isLayoutYDirty = true;
					child.markChildrenLayoutYDirty();
				}
			}
		}

		override public function set width(value:Number):void
		{
			super.width = value;
			invalidateLayoutX();
		}

		override public function set height(value:Number):void
		{
			super.height = value;
			invalidateLayoutY();
		}

		public function get centerX():Number
		{
			return _centerX;
		}

		public function set centerX(value:Number):void
		{
			invalidateLayoutX(isNaN(value));
			_centerX = value;
		}

		public function get centerY():Number
		{
			return _centerY;
		}

		public function set centerY(value:Number):void
		{
			invalidateLayoutY(isNaN(value));
			_centerY = value;
		}

		public function get left():Number
		{
			return _left;
		}

		public function set left(value:Number):void
		{
			invalidateLayoutX();
			_left = value;
		}

		public function get right():Number
		{
			return _right;
		}

		public function set right(value:Number):void
		{
			invalidateLayoutX();
			_right = value;
		}

		public function get top():Number
		{
			return _top;
		}

		public function set top(value:Number):void
		{
			invalidateLayoutY();
			_top = value;
		}

		public function get bottom():Number
		{
			return _bottom;
		}

		public function set bottom(value:Number):void
		{
			invalidateLayoutY();
			_bottom = value;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return addChildAt(child, numChildren);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			super.addChildAt(child, index);
			var layoutObject:LayoutObject = child as LayoutObject;
			if(layoutObject != null){
				layoutObject.invalidateLayoutX();
				layoutObject.invalidateLayoutY();
			}
			return child;
		}
		
		virtual protected function onSizeChanged(wFlag:Boolean, hFlag:Boolean):void{}
	}
}