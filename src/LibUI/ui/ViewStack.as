package ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class ViewStack extends Sprite
	{
		private var focusChild:DisplayObject;
		
		public function ViewStack()
		{
			super();
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			child.visible = false;
			super.addChildAt(child, index);
			if(null == focusChild){
				setFocus(child);
			}
			return child;
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject = super.removeChildAt(index);
			if(child == focusChild){
				setFocus(null);
			}
			return child;
		}
		
		public function setFocus(child:DisplayObject):void
		{
			if(focusChild != child){
				if(focusChild){
					focusChild.visible = false;
				}
				focusChild = child;
				if(focusChild){
					focusChild.visible = true;
				}
			}
		}
		
		public function setFocusAt(index:int):void
		{
			var child:DisplayObject = getChildAt(index);
			setFocus(child);
		}
	}
}