package htmlui
{
	import flash.display.DisplayObject;

	public interface IUIContainer
	{
		function addElement(child:DisplayObject, option:Object=null):DisplayObject;
		function addElementAt(child:DisplayObject, index:int, option:Object=null):DisplayObject;
		function removeElement(child:DisplayObject):DisplayObject;
		function removeElementAt(index:int):DisplayObject;
	}
}