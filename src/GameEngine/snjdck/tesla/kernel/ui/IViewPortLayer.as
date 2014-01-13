package snjdck.tesla.kernel.ui
{
	import flash.display.DisplayObject;
	
	public interface IViewPortLayer
	{
		function addChild(child:DisplayObject):DisplayObject;
		function removeChild(child:DisplayObject):DisplayObject;
		function contains(child:DisplayObject):Boolean;
		function get numChildren():int;
		function getChildIndex(child:DisplayObject):int;
		function swapChildrenAt(index1:int, index2:int):void;
	}
}