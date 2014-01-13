package htmlui
{
	import flash.display.DisplayObject;
	import htmlui.layout.Layout;

	public class UIObjectContainer extends UIObject implements IUIContainer
	{
		private var _layout:Layout;
		
		public function UIObjectContainer()
		{
			_layout = new Layout(this);
		}
		
		public function get layout():Layout
		{
			return _layout;
		}

		public function set layout(value:Layout):void
		{
			_layout = value;
		}

		public function addElement(child:DisplayObject, option:Object=null):DisplayObject
		{
			return _layout.addElement(child, option);
		}
		
		public function addElementAt(child:DisplayObject, index:int, option:Object=null):DisplayObject
		{
			return _layout.addElementAt(child, index, option);
		}
		
		public function removeElement(child:DisplayObject):DisplayObject
		{
			return _layout.removeElement(child);
		}
		
		public function removeElementAt(index:int):DisplayObject
		{
			return _layout.removeElementAt(index);
		}
	}
}