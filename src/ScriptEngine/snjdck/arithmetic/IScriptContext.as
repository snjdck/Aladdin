package snjdck.arithmetic
{
	public interface IScriptContext
	{
		function getValue(key:String):*;
		function setValue(key:String, value:Object):void;
		
		function hasKey(key:String, searchParent:Boolean):Boolean;
		function newKey(key:String, value:Object):void;
		function delKey(key:String):void;
		
		function createChildContext():IScriptContext;
	}
}