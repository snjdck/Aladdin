package snjdck.g2d.core
{
	public interface IDisplayObjectContainer2D extends IDisplayObject2D
	{
		function get numChildren():int;
		
		function addChild(child:IDisplayObject2D):void;
		function addChildAt(child:IDisplayObject2D, index:int):void;
		
		function removeChild(child:IDisplayObject2D):void;
		function removeChildAt(index:int):IDisplayObject2D;
		
		function contains(child:IDisplayObject2D):Boolean;
		
		function getChildAt(index:int):IDisplayObject2D;
		function getChildIndex(child:IDisplayObject2D):int;
		
		function setChildIndex(child:IDisplayObject2D, index:int):void;
		function swapChildren(child1:IDisplayObject2D, child2:IDisplayObject2D):void;
		function swapChildrenAt(index1:int, index2:int):void;
	}
}