package snjdck.ui.list
{
	import flash.display.IDisplayObject;
	import flash.signals.ISignal;
	
	public interface IList extends IDisplayObject
	{
		function get selectedSignal():ISignal;
		
		function clear():void;
		function setValue(value:Array):void;
		function getValue():Array;
		
		function get selectedIndex():int;
		function set selectedIndex(value:int):void;
		function get selectedData():*;
		function get numCols():int;
		function set numCols(value:int):void;
		function get hGap():Number;
		function set hGap(value:Number):void;
		function get vGap():Number;
		function set vGap(value:Number):void;
		
		function get listItemFactory():Class;
		function set listItemFactory(value:Class):void;
		function get labelField():String;
		function set labelField(value:String):void;
	}
}