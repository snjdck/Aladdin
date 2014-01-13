package htmlui
{
	import flash.geom.Point;
	
	import snjdck.signal.ISignal;

	public interface IUIObject
	{
		function get x():Number;
		function get y():Number;
		function get width():Number;
		function get height():Number;
		
		function set x(value:Number):void;
		function set y(value:Number):void;
		function set width(value:Number):void;
		function set height(value:Number):void;
		
		function get viewAreaChangeSignal():ISignal;
		function localToGlobal(value:Point):Point;
		function globalToLocal(value:Point):Point;
	}
}