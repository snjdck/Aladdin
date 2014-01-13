package htmlui.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
	import array.del;
	
	import htmlui.IUIContainer;

	public class Layout implements IUIContainer
	{
		protected var _elementList:Vector.<DisplayObject>;
		protected var _elementDict:Object;
		protected var _target:DisplayObjectContainer;
		
		public function Layout(target:DisplayObjectContainer)
		{
			this._elementList = new Vector.<DisplayObject>();
			this._elementDict = new Dictionary(true);
			this._target = target;
		}
		
		final public function addElement(child:DisplayObject, option:Object=null):DisplayObject
		{
			return addElementAt(child, _target.numChildren, option);
		}
		
		public function addElementAt(child:DisplayObject, index:int, option:Object=null):DisplayObject
		{
			_elementList.push(child);
			_elementDict[child] = option;
			_target.addChildAt(child, index);
			relayout();
			return child;
		}
		
		public function removeElement(child:DisplayObject):DisplayObject
		{
			array.del(_elementList, child);
			delete _elementDict[child];
			_target.removeChild(child);
			relayout();
			return child;
		}
		
		final public function removeElementAt(index:int):DisplayObject
		{
			return removeElement(_target.getChildAt(index));
		}
		
		virtual protected function relayout():void
		{
			
		}
	}
}