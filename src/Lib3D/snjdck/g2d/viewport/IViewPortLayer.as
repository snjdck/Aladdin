package snjdck.g2d.viewport
{
	import snjdck.g2d.impl.DisplayObject2D;
	
	public interface IViewPortLayer
	{
		function addChild(child:DisplayObject2D):void;
		function removeChild(child:DisplayObject2D):void;
		function contains(child:DisplayObject2D):Boolean;
		function get numChildren():int;
		function getChildIndex(child:DisplayObject2D):int;
		function swapChildrenAt(index1:int, index2:int):void;
	}
}